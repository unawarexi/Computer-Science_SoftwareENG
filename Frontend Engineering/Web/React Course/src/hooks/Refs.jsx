import React, { useRef } from "react";

function RefExample() {
  // Create a reference to the input element
  const inputRef = useRef(null);

  // Function to focus the input field
  const focusInput = () => {
    inputRef.current.focus();
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      {/* Input field with a ref attached */}
      <input
        ref={inputRef}
        type="text"
        placeholder="Type something..."
        className="px-4 py-2 border rounded-lg shadow-md focus:outline-none focus:ring-2 focus:ring-blue-500 mb-4"
      />
      {/* Button to focus the input field */}
      <button
        onClick={focusInput}
        className="px-6 py-2 bg-blue-500 text-white rounded-lg shadow-md hover:bg-blue-600 transition duration-300"
      >
        Focus Input
      </button>
    </div>
  );
}

export default RefExample;
