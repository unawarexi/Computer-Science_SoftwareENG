// reducer.js

import { ADD_ITEM, REMOVE_ITEM, CLEAR_CART } from "../actions/CartActions";

// Initial state for the cart
const initialState = {
  items: [],
  message: "",
};

// Reducer function to handle actions and update the state
const cartReducer = (state = initialState, action) => {
  switch (action.type) {
    case ADD_ITEM:
      // Add item to the cart and update the message
      return {
        ...state,
        items: [...state.items, action.payload],
        message: "Item added successfully",
      };
    case REMOVE_ITEM:
      // Remove item from the cart and update the message
      const updatedItems = state.items.filter(
        (item) => item !== action.payload
      );
      return {
        ...state,
        items: updatedItems,
        message: updatedItems.length
          ? "Item removed successfully"
          : "Add an item",
      };
    case CLEAR_CART:
      // Clear all items from the cart and update the message
      return {
        ...state,
        items: [],
        message: "Cart cleared",
      };
    default:
      return state;
  }
};

export default cartReducer;
