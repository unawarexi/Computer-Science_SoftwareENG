import React, { useEffect } from "react";

function Effects() {
  // Simulate fetching data or running an effect when the component mounts
  useEffect(() => {
    // This code runs when the component is mounted
    console.log("Component mounted");

    // Cleanup function, runs when the component is unmounted
    return () => {
      console.log("Component unmounted");
    };
  }, []); // Empty dependency array ensures this effect only runs once on mount and cleanup on unmount

  return (
    <div className="flex flex-col items-center justify-center min-h-60 shadow-lg shadow-red-500  bg-gray-100">
      {/* Displaying a simple message */}
      <h1 className="text-4xl font-bold text-gray-800 mb-4">
        Check the console!
      </h1>
      <p className="text-lg text-gray-600">
        This component logs messages on mount and unmount.
      </p>
    </div>
  );
}

export default Effects;
