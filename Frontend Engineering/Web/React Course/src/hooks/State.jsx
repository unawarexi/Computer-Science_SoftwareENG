import React, { useState } from "react";

function StateExample() {
  // Declare a state variable named 'count' with an initial value of 0
  const [count, setCount] = useState(0);

  // Function to handle the increment of the count
  const handleIncrement = () => {
    setCount(count + 2);
  };

  // Function to handle the decrement of the count
  const handleDecrement = () => {
    setCount(count - 1);
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-60 shadow-lg shadow-red-500 bg-gray-100">
      {/* Displaying the current count */}
      <h1 className="text-4xl font-bold text-gray-800 mb-4">
        Current Count: {count}
      </h1>

      {/* Button to increment the count */}
      <button
        onClick={handleIncrement}
        className="px-6 py-2 bg-blue-500 text-white rounded-lg shadow-md hover:bg-blue-600 transition duration-300 mb-2"
      >
        Increment
      </button>

      {/* Button to decrement the count */}
      <button
        onClick={handleDecrement}
        className="px-6 py-2 bg-red-500 text-white rounded-lg shadow-md hover:bg-red-600 transition duration-300"
      >
        Decrement
      </button>
    </div>
  );
}

export default StateExample;
