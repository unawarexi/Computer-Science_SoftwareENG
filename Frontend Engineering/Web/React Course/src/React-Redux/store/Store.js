// store.js
/**
 * Create the Redux store using the cartReducer
 * the create store is an in built function from redux itself
 *
 *
 */

import { createStore } from "redux";
import cartReducer from "../reducer/CartReducer";

// Create the store with the cart reducer
const store = createStore(cartReducer);

export default store;
