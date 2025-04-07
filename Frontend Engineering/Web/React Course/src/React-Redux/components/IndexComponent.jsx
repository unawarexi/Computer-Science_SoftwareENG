// IndexComponent.js

import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { addItem, removeItem, clearCart } from "../actions/CartActions"; // Import action creators

const IndexComponent = () => {
  // Get dispatch function from Redux
  const dispatch = useDispatch();

  // Get current state from Redux store
  const { items, message } = useSelector((state) => state);

  // Function to handle adding an item
  const handleAddItem = () => {
    const item = "New Item";
    dispatch(addItem(item));
  };

  // Function to handle removing an item
  const handleRemoveItem = () => {
    const item = "New Item";
    dispatch(removeItem(item));
  };

  // Function to handle clearing the cart
  const handleClearCart = () => {
    dispatch(clearCart());
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-4">
      <div className="text-center mb-4">
        <button
          onClick={handleAddItem}
          className="bg-blue-500 text-white py-2 px-4 rounded m-2"
        >
          Add Item
        </button>
        <button
          onClick={handleRemoveItem}
          className="bg-red-500 text-white py-2 px-4 rounded m-2"
        >
          Remove Item
        </button>
        <button
          onClick={handleClearCart}
          className="bg-gray-500 text-white py-2 px-4 rounded m-2"
        >
          Clear Cart
        </button>
      </div>

      {/* Display the message */}
      <p
        className={`text-lg font-semibold ${
          message === "Add an item" ? "text-red-500" : "text-green-500"
        }`}
      >
        {message}
      </p>

      {/* List of items */}
      <ul className="list-disc mt-4">
        {items.map((item, index) => (
          <li key={index} className="text-lg">
            {item}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default IndexComponent;
