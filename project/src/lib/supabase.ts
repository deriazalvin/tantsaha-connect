import { createClient } from '@supabase/supabase-js';
import type { Database } from './database.types';

// Supabase client removed during migration to backend APIs.
// Keep a lightweight placeholder to avoid build errors in case
// some files still import this module during transition.
export const supabase = {} as any;
