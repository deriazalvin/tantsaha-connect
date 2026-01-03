import { createContext, useContext, useEffect, useState } from 'react';
import type { Database } from '../lib/database.types';

type Profile = Database['public']['Tables']['profiles']['Row'];
type Region = Database['public']['Tables']['regions']['Row'];

interface AuthContextType {
  user: { id: string; email?: string } | null;
  profile: Profile | null;
  region: Region | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<{ error?: string | null }>;
  signUp: (email: string, password: string, fullName?: string, regionId?: string, phone?: string) => Promise<{ error?: string | null }>;
  signOut: () => void;
  updateProfile: (updates: Partial<Profile>) => Promise<{ error?: string | null }>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const API_BASE = import.meta.env.VITE_API_URL ?? 'http://localhost:4000';
const TOKEN_KEY = 'tantsaha_token';

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<{ id: string; email?: string } | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [region, setRegion] = useState<Region | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      const token = localStorage.getItem(TOKEN_KEY);
      if (!token) {
        setLoading(false);
        return;
      }

      try {
        const res = await fetch(`${API_BASE}/api/profiles/me`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        if (!res.ok) {
          localStorage.removeItem(TOKEN_KEY);
          setLoading(false);
          return;
        }
        const profileData = await res.json();
        setProfile(profileData);
        setUser({ id: profileData.id });
        // backend now returns a nested `region` (id + name) when available
        if (profileData?.region) {
          setRegion(profileData.region as Region);
        }
      } catch (err) {
        console.error('Auth init error', err);
        localStorage.removeItem(TOKEN_KEY);
      } finally {
        setLoading(false);
      }
    })();
  }, []);

  const signIn = async (email: string, password: string) => {
    try {
      const res = await fetch(`${API_BASE}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        return { error: body.error || 'Login failed' };
      }
      const data = await res.json();
      localStorage.setItem(TOKEN_KEY, data.token);
      setUser({ id: data.user.id, email: data.user.email });
      // load profile (API returns nested region)
      const p = await fetch(`${API_BASE}/api/profiles/me`, { headers: { Authorization: `Bearer ${data.token}` } });
      if (p.ok) {
        const profileData = await p.json();
        setProfile(profileData);
        if (profileData?.region) setRegion(profileData.region as Region);
      }
      return { error: null };
    } catch (err) {
      console.error(err);
      return { error: 'Login error' };
    }
  };

  const signUp = async (email: string, password: string, fullName?: string, regionId?: string, phone?: string) => {
    try {
      const payload: any = { email, password, full_name: fullName, phone };
      if (regionId) payload.region_id = regionId;

      const res = await fetch(`${API_BASE}/auth/signup`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });

      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        return { error: body.error || 'Signup failed' };
      }

      const data = await res.json();
      localStorage.setItem(TOKEN_KEY, data.token);
      setUser({ id: data.user.id, email: data.user.email });

      const p = await fetch(`${API_BASE}/api/profiles/me`, { headers: { Authorization: `Bearer ${data.token}` } });
      if (p.ok) {
        const profileData = await p.json();
        setProfile(profileData);
        if (profileData?.region) setRegion(profileData.region as Region);
      }

      return { error: null };
    } catch (err) {
      console.error(err);
      return { error: 'Signup error' };
    }
  };


  const signOut = () => {
    localStorage.removeItem(TOKEN_KEY);
    setUser(null);
    setProfile(null);
    setRegion(null);
  };

  const updateProfile = async (updates: Partial<Profile>) => {
    const token = localStorage.getItem(TOKEN_KEY);
    if (!token) return { error: 'Not authenticated' };
    try {
      const res = await fetch(`${API_BASE}/api/profiles`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
        body: JSON.stringify(updates),
      });
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        return { error: body.error || 'Update failed' };
      }
      const updated = await res.json();
      setProfile(updated);
      if (updates.region_id) {
        // fetch updated profile to get the nested region object
        const token = localStorage.getItem(TOKEN_KEY);
        if (token) {
          const p = await fetch(`${API_BASE}/api/profiles/me`, { headers: { Authorization: `Bearer ${token}` } });
          if (p.ok) {
            const profileData = await p.json();
            if (profileData?.region) setRegion(profileData.region as Region);
          }
        }
      }
      return { error: null };
    } catch (err) {
      console.error(err);
      return { error: 'Update error' };
    }
  };

  return (
    <AuthContext.Provider
      value={{ user, profile, region, loading, signIn, signUp, signOut, updateProfile }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
