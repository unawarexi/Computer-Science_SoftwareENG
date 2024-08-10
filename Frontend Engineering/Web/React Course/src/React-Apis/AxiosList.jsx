import React, { useState, useEffect } from "react";
import axios from "axios";
import Categories from "./Categories";

function AxiosList() {
  // State to hold the list of recipes
  const [recipes, setRecipes] = useState([]);
  // State to hold the user's query input
  const [query, setQuery] = useState("vegan");
  // State to track if the component is loading data
  const [isLoading, setIsLoading] = useState(false);

  // Base URL for the API
  const BASE_URL = "https://www.themealdb.com/api/json/v1/1/search.php";

  // Function to fetch recipes based on a query
  const fetchRecipes = async (query) => {
    setIsLoading(true); // Set loading state to true
    try {
      // Make GET request to the API with the query parameter
      const response = await axios.get(BASE_URL, {
        params: {
          s: query,
        },
      });
      // Set the response data (meals) to the recipes state
      setRecipes(response.data.meals);
      console.log(response.data.meals);
    } catch (error) {
      // Log any errors during the fetch
      console.error("Error fetching recipes:", error);
    } finally {
      setIsLoading(false); // Set loading state to false
    }
  };

  // useEffect to fetch recipes when the component mounts or query changes
  useEffect(() => {
    fetchRecipes(query); // Fetch recipes with the current query
  }, [query]);

  // Handle form submission
  const handleSubmit = (event) => {
    event.preventDefault(); // Prevent default form submission
    fetchRecipes(query); // Fetch recipes with the new query
  };

  return (
    <div className="container mx-auto p-4">
      <Categories />
      <h1 className="text-2xl font-bold mb-4">Recipe List</h1>
      {/* Form to input query */}
      <form onSubmit={handleSubmit} className="mb-4">
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="border border-gray-300 p-2 rounded w-full md:w-1/2"
          placeholder="Enter recipe category"
        />
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded ml-2"
        >
          Search
        </button>
      </form>
      {/* Grid container with 4 columns */}
      <ul className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Check if recipes are available */}
        {isLoading ? (
          // Show loading message while fetching data
          <p className="text-gray-500">Loading recipes...</p>
        ) : recipes && recipes.length > 0 ? (
          recipes.map((recipe) => (
            // Each recipe item
            <li
              key={recipe.idMeal}
              className="p-4 border border-gray-200 rounded-lg shadow-sm"
            >
              {" "}
              {/* Recipe image */}
              <img
                src={recipe.strMealThumb}
                alt={recipe.strMeal}
                className="w-full h-auto mt-2 rounded"
              />
              {/* Recipe title */}
              <h2 className="text-xl font-semibold pt-4">{recipe.strMeal}</h2>
              {/* Recipe instructions */}
              {/* <p className="text-gray-700">{recipe.strInstructions}</p> */}
            </li>
          ))
        ) : (
          // Message if no recipes are found
          <p className="text-gray-500">No recipes found.</p>
        )}
      </ul>
    </div>
  );
}

export default AxiosList;
