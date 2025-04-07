import React, { useRef, useImperativeHandle, forwardRef } from "react";

// Child component wrapped with forwardRef to use useImperativeHandle
const CustomButton = forwardRef((props, ref) => {
  // Create a ref for the button element
  const buttonRef = useRef(null);

  // Use useImperativeHandle to expose specific functions or values to the parent component
  useImperativeHandle(ref, () => ({
    clickButton() {
      buttonRef.current.click();
    },
  }));

  return (
    <button
      ref={buttonRef}
      className="px-6 py-2 bg-blue-500 text-white rounded-lg shadow-md hover:bg-blue-600 transition duration-300"
    >
      Click Me
    </button>
  );
});

function ImperativeHandleExample() {
  const buttonRef = useRef(null);

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      {/* Custom button that exposes its click function to the parent */}
      <CustomButton ref={buttonRef} />
      {/* Button to trigger the click function on the custom button */}
      <button
        onClick={() => buttonRef.current.clickButton()}
        className="mt-4 px-6 py-2 bg-green-500 text-white rounded-lg shadow-md hover:bg-green-600 transition duration-300 / that you cann"
      >
        Trigger Custom Button Click
      </button>
    </div>
  );
}

export default ImperativeHandleExample;
