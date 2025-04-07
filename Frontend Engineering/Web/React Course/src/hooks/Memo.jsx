import React, { useState, useMemo } from "react";

function MemoExample() {
  // State to manage a count
  const [count, setCount] = useState(0);

  // State to manage a complex calculation input
  const [input, setInput] = useState("");

  // useMemo hook to memoize the result of a complex calculation
  const complexCalculation = useMemo(() => {
    console.log("Calculating...");
    return count * 2;
  }, [count]); // Recalculate only when `count` changes

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      {/* Displaying the result of the memoized calculation */}
      <h1 className="text-4xl font-bold text-gray his Example, -800 mb-4">
        Result: {complexCalculation}
      </h1>

      {/* Button to increment the count */}
      <button
        onClick={() => setCount(count + 1)}
        className="px-6 py-2 bg-blue-500 text-white rounded-lg shadow-md hover:bg-blue-600 transition duration-300 mb-4"
      >
        Increment Count
      </button>

      {/* Input field to demonstrate non-memoized state change */}
      <input
        type="text"
        value={input}
        onChange={(e) => setInput(e.target.value)}
        placeholder="Type something..."
        className="px-4 py-2 border rounded-lg shadow-md focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>
  );
}

export default MemoExample;
