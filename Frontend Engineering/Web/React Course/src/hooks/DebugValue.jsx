import React, { useState, useEffect, useDebugValue } from "react";

// Custom hook to demonstrate useDebugValue
function useOnlineStatus() {
  const [isOnline, setIsOnline] = useState(navigator.onLine);

  useDebugValue(isOnline ? "Online" : "Offline");

  useEffect(() => {
    const handleStatusChange = () => {
      setIsOnline(navigator.onLine);
    };

    window.addEventListener("online", handleStatusChange);
    window.addEventListener("offline", handleStatusChange);

    return () => {
      window.removeEventListener("online", handleStatusChange);
      window.removeEventListener("offline", handleStatusChange);
    };
  }, []);

  return isOnline;
}

function DebugValueExample() {
  const isOnline = useOnlineStatus();

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <h1 className="text-2xl font-bold text-gray-800 mb-4">
        You are currently: {isOnline ? "Online" : "Offline"}
      </h1>
    </div>
  );
}

export default DebugValueExample;
