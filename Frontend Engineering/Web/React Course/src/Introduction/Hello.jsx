import React from "react";

const topics = {
  Basics: [
    "JSX",
    "Components",
    "Props",
    "State",
    "Event Handling",
    "Form Authentications",
  ],
  Intermediate: [
    "Hooks",
    "Axios API Call",
    "Context API",
    "Lifecycle Methods",
    "Error Boundaries",
  ],

  Libraries: ["React Queries", "React Formik", "Yup", "Axios"],

  Advanced: [
    "Performance Optimization",
    "Code Splitting",
    "Server-Side Rendering",
    "Static Site Generation",
  ],
  "State Management": ["Redux", "MobX", "Recoil", "Zustand"],
  Routing: [
    "React Router",
    "Dynamic Routing",
    "Nested Routing",
    "Programmatic Navigation",
  ],
};

const HomePage = () => {
  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <h1 className="text-3xl font-bold text-center mb-8">React Topics</h1>
      <div className="space-y-12">
        {Object.entries(topics).map(([category, buttons]) => (
          <div key={category} className="bg-white shadow-md rounded-lg p-6">
            <h2 className="text-2xl font-semibold mb-4 border-b-2 border-gray-300 pb-2">
              {category}
            </h2>
            <div className="flex flex-wrap gap-4">
              {buttons.map((topic) => (
                <button
                  key={topic}
                  className="bg-blue-500 text-white py-2 px-4 rounded-lg shadow-md hover:bg-blue-600 transition duration-300"
                >
                  {topic}
                </button>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default HomePage;
