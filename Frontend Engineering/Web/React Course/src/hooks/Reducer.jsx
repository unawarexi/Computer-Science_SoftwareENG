import React, { useReducer } from "react";

/**
 *  use reducer combines several actions in an excutable function
 *  it can only be updated using the action types
 *  it takes two params "initialState and function actions"
 *  makes use of a switch statement
 *  uses dispatch as a function call to use each action type
 */

// Define the initial state
const initialState = { count: 0 };

// Reducer function to handle state transitions
function reducer(state, action) {
  switch (action.type) {
    case "increment":
      return { count: state.count + 1 };
    case "decrement":
      return { count: state.count - 1 };
    case "reset":
      return { count: 0 };
    default:
      return state;
  }
}

function ReducerExample() {
  // useReducer hook to manage the state based on the reducer function
  const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <div className="flex flex-col items-center justify-center min-h-72 shadow-lg shadow-red-500 bg-gray-100">
      {/* Displaying the current count */}
      <h1 className="text-4xl font-bold text-gray-800 mb-4">
        Current Count: {state.count}
      </h1>

      {/* Button to increment the count */}
      <button
        onClick={() => dispatch({ type: "increment" })}
        className="px-6 py-2 bg-blue-500 text-white rounded-lg shadow-md hover:bg-blue-600 transition duration-300 mb-2"
      >
        Add Item
      </button>

      {/* Button to decrement the count */}
      <button
        onClick={() => dispatch({ type: "decrement" })}
        className="px-6 py-2 bg-red-500 text-white rounded-lg shadow-md hover:bg-red-600 transition duration-300 mb-2"
      >
        Remove item
      </button>

      {/* Button to reset the count */}
      <button
        onClick={() => dispatch({ type: "reset" })}
        className="px-6 py-2 bg-gray-500 text-white rounded-lg shadow-md hover:bg-gray-600 transition duration-300"
      >
        Clear Cart
      </button>
    </div>
  );
}

export default ReducerExample;
