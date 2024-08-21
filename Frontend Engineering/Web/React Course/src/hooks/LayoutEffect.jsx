import React, { useState, useLayoutEffect, useRef } from "react";

function LayoutEffectExample() {
  const [width, setWidth] = useState(0);
  const boxRef = useRef(null);

  // Measure the width of the box after DOM updates
  useLayoutEffect(() => {
    setWidth(boxRef.current.offsetWidth);
  }, []);

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <div
        ref={boxRef}
        className="w-64 h-64 bg-green-500 text-white flex items-center justify-center"
      >
        Box Width: {width}px
      </div>
    </div>
  );
}

export default LayoutEffectExample;
