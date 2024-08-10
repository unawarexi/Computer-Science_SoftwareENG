import React, { useState, useEffect } from "react";
import axios from "axios";

const Categories = () => {
  // State to store categories data
  const [categories, setCategories] = useState([]);
  // State to manage loading status
  const [loading, setLoading] = useState(true);
  // State to handle error if API call fails
  const [error, setError] = useState(null);

  // useEffect to fetch data from API when the component mounts
  useEffect(() => {
    // Fetch data from the API
    axios
      .get("https://www.themealdb.com/api/json/v1/1/categories.php")
      .then((response) => {
        // Update categories state with fetched data
        setCategories(response.data.categories);
        // Set loading to false as data fetching is complete
        setLoading(false);
      })
      .catch((error) => {
        // Set error state if there's an error during fetching
        setError(error);
        // Set loading to false as data fetching is complete even with an error
        setLoading(false);
      });
  }, []);

  // Utility function to truncate text to a specified number of words
  const truncateText = (text, wordLimit) => {
    // Split text into an array of words
    const words = text.split(" ");
    // Check if the number of words exceeds the limit
    if (words.length > wordLimit) {
      // Return the first 'wordLimit' words joined by space, followed by "..."
      return words.slice(0, wordLimit).join(" ") + "...";
    }
    // Return original text if word count is within the limit
    return text;
  };

  // Display loading message if data is still being fetched
  if (loading) {
    return (
      <div className="flex justify-center items-center h-screen">
        <p>Loading...</p>
      </div>
    );
  }

  // Display error message if there was an error during fetching
  if (error) {
    return (
      <div className="flex justify-center items-center h-screen">
        <p>Error loading categories.</p>
      </div>
    );
  }

  // Render the categories once data is fetched and no error occurred
  return (
    <div className="min-h-screen bg-gray-100 p-6">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-4xl font-bold text-center mb-8">Categories</h1>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
          {categories.map((category) => (
            <div
              key={category.idCategory}
              className="bg-white rounded-lg shadow-md overflow-hidden"
            >
              {/* Display category thumbnail image */}
              <img
                src={category.strCategoryThumb}
                alt={category.strCategory}
                className="w-full h-36 object-cover"
              />
              <div className="p-4">
                {/* Display category name */}
                <h2 className="text-2xl font-bold mb-2">
                  {category.strCategory}
                </h2>
                {/* Display truncated category description */}
                <p className="text-gray-700">
                  {truncateText(category.strCategoryDescription, 20)}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Categories;
