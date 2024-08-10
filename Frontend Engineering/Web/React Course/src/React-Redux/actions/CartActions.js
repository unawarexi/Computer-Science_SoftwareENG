/**
 * Actions are plain JavaScript objects that describe what happened.
 * Actions: Payloads of information that send data from your application to your Redux store.
 * These are the only source of information for the store.
 *
 * so basically you Define actions to describe what happens in the app.
 * @param {*} item
 */

// define the action types as constants
// actions.js

// Define action types
export const ADD_ITEM = "ADD_ITEM";
export const REMOVE_ITEM = "REMOVE_ITEM";
export const CLEAR_CART = "CLEAR_CART";

// Action creators
export const addItem = (item) => ({
  type: ADD_ITEM,
  payload: item,
});

export const removeItem = (item) => ({
  type: REMOVE_ITEM,
  payload: item,
});

export const clearCart = () => ({
  type: CLEAR_CART,
});
