import React, { useState, useCallback } from "react";

// A child component that receives a function as a prop
const ChildComponent = React.memo(({ handleClick }) => {
  console.log("ChildComponent rendered");
  return (
    <button
      onClick={handleClick}
      className="px-6 py-2 bg-blue-500 text-white rounded-lg shadow-md hover:bg-blue-600 transition duration-300"
    >
      Click Me
    </button>
  );
});

function CallbackExample() {
  // State to manage a counter
  const [count, setCount] = useState(0);

  // useCallback hook to memoize the handleClick function
  const handleClick = useCallback(() => {
    setCount((prevCount) => prevCount + 1);
  }, []); // The empty dependency array means this function is created only once

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      {/* Displaying the current count */}
      <h1 className="text-4xl font-bold text-gray-800 mb-4">Count: {count}</h1>

      {/* Passing the memoized handleClick function to the childComponent */}
      <ChildComponent handleClick={handleClick} />
    </div>
  );
}

export default CallbackExample;
