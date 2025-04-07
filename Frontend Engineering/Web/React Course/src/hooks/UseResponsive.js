import { useState, useEffect } from "react";

const useResponsiveness = () => {
  const [windowSize, setWindowSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  useEffect(() => {
    const handleResize = () => {
      setWindowSize({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    };

    window.addEventListener("resize", handleResize);

    // Cleanup the event listener on component unmount
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  // You can customize the breakpoints according to your needs
  const isMobile = windowSize.width <= 768;
  const isTablet = windowSize.width > 768 && windowSize.width <= 1024;
  const isDesktop = windowSize.width > 1024;

  return { windowSize, isMobile, isTablet, isDesktop };
};

export default useResponsiveness;

// function ResponsiveComponent() {
//   const [width, setwidth] = useState(window.innerWidth);

//   useEffect(() => {
//     // RUN EFFECTS AFTER COMPONENTS MOUNTS
//     const handleSize = () => {
//       setwidth(window.innerWidth);
//     };

//     window.addEventListener("resize", handleSize);
//     // CLEAR EFFECTS AFTER COMPONENTS MOUNTS
//     return () => {
//       window.removeEventListener("resize", handleSize);
//     };
//   }, []); // EFFECT IS TO RUN ONLY ONCE

//   return width;
// }

// export default ResponsiveComponent;
