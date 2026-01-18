import { useMemo, useState } from "react";
import { AnimatePresence } from "framer-motion";

import { useAuth } from "./contexts/AuthContext";

import Login from "./components/Login";
import Register from "./components/Register";

import Dashboard from "./components/Dashboard";
import Weather from "./components/Weather";
import Alerts from "./components/Alerts";
import Advice from "./components/Advice";
import Journal from "./components/Journal";

import CubeTransition from "./components/UI/CubeTransition";

function App() {
  const { user, loading } = useAuth();

  const [authMode, setAuthMode] = useState<"login" | "register">("login");
  const [currentScreen, setCurrentScreen] = useState<
    "dashboard" | "weather" | "alerts" | "advice" | "journal"
  >("dashboard");

  const handleNavigate = (screen: string) => {
    setCurrentScreen(screen as any);
  };

  const page = useMemo(() => {
    switch (currentScreen) {
      case "weather":
        return <Weather onNavigate={handleNavigate} />;
      case "alerts":
        return <Alerts onNavigate={handleNavigate} />;
      case "advice":
        return <Advice onNavigate={handleNavigate} />;
      case "journal":
        return <Journal onNavigate={handleNavigate} />;
      default:
        return <Dashboard onNavigate={handleNavigate} />;
    }
  }, [currentScreen]);

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center">
        <div className="text-slate-600">Mahandrasa...</div>
      </div>
    );
  }

  if (!user) {
    return authMode === "login" ? (
      <Login onShowRegister={() => setAuthMode("register")} />
    ) : (
      <Register onShowLogin={() => setAuthMode("login")} />
    );
  }

  return (
    <AnimatePresence mode="wait" initial={false}>
      <CubeTransition key={currentScreen} direction="left" duration={0.95}>
        {page}
      </CubeTransition>
    </AnimatePresence>
  );
}

export default App;
