import React, { useContext, useState, useEffect } from "react";
import axios from "axios";
import Categories from "./Categories";
import { CategoriesContext } from "../context/ContextProvider";
function AxiosList() {
  const { recipes, query, setQuery, isLoading, handleSubmit } =
    useContext(CategoriesContext);

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
