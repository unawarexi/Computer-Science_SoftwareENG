import React, { useContext, useState, useEffect } from "react";
import axios from "axios";

import useResponsiveness from "../hooks/UseResponsive";

import { CategoriesContext } from "../context/ContextProvider";

const Categories = () => {
  const { categories, loadingCategories, error, truncateText } =
    useContext(CategoriesContext);

  const { isMobile, isTablet, isDesktop } = useResponsiveness();

  // Display loading message if data is still being fetched
  if (loadingCategories) {
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
                {isMobile || isDesktop ? (
                  <h2 className="text-2xl text-red-500 font-bold mb-2">
                    {category.strCategory}
                  </h2>
                ) : (
                  <h2 className="text-2xl font-bold mb-2">
                    {category.strCategory}
                  </h2>
                )}
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
