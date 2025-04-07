import React, { createContext, useEffect, useState } from "react";
import axios from "axios";

// Create a context for Categories
const CategoriesContext = createContext();

const ContextProvider = ({ children }) => {
  /**---------- states -----------------/
   * State to hold the list of recipes
   * State to hold the user's query input
   * State to track if the component is loading data
   *
   *
   * State to store categories data
   * State to manage loading status for categories
   * State to handle error if API call fails
   *
   */

  const [recipes, setRecipes] = useState([]);
  const [query, setQuery] = useState("vegan");
  const [isLoading, setIsLoading] = useState(false);

  /**------- CATEGORIES ------------ */
  const [categories, setCategories] = useState([]);
  const [loadingCategories, setLoadingCategories] = useState(true);
  const [error, setError] = useState(null);

  // Base URLs for the APIs
  const BASE_URL_RECIPES = import.meta.env.VITE_BASE_URL_RECIPES;
  const BASE_URL_CATEGORIES = import.meta.env.VITE_BASE_URL_CATEGORIES;

  /** -------------Function to fetch recipes based on a query
   * Make GET request to the API with the query parameter
   * Set the response data (meals) to the recipes state
   *  Log any errors during the fetch
   */
  const fetchRecipes = async (query) => {
    setIsLoading(true); // Set loading state to true
    try {
      const response = await axios.get(BASE_URL_RECIPES, {
        params: {
          s: query,
        },
      });

      setRecipes(response.data.meals);
      console.log(response.data.meals);
    } catch (error) {
      console.error("Error fetching recipes:", error);
    } finally {
      setIsLoading(false); // Set loading state to false
    }
  };

  // Function to fetch categories
  const fetchCategories = async () => {
    setLoadingCategories(true); // Set loading state to true
    try {
      // Fetch data from the API
      const response = await axios.get(BASE_URL_CATEGORIES);
      // Update categories state with fetched data
      if (response && response.data && response.data.categories) {
        setCategories(response.data.categories);
      }
    } catch (error) {
      // Set error state if there's an error during fetching
      setError(error);
      console.error("Error fetching categories:", error);
    } finally {
      setLoadingCategories(false); // Set loading state to false
    }
  };

  // useEffect to fetch both recipes and categories when the component mounts
  useEffect(() => {
    fetchRecipes(query); // Fetch recipes with the current query
    fetchCategories(); // Fetch categories data
  }, [query]); // Only re-run when `query` changes
  // Handle form submission

  const handleSubmit = (event) => {
    event.preventDefault(); // Prevent default form submission
    fetchRecipes(query); // Fetch recipes with the new query
  };

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

  return (
    <CategoriesContext.Provider
      value={{
        recipes,
        isLoading,
        categories,
        loadingCategories,
        error,
        setQuery,
        handleSubmit,
        truncateText,
      }}
    >
      {children}
    </CategoriesContext.Provider>
  );
};

export { ContextProvider, CategoriesContext };
