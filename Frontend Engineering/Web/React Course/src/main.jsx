import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";

import { createStore } from "redux";

import { Provider } from "react-redux";
import store from "./React-Redux/store/Store.js";

import { BrowserRouter as Router } from "react-router-dom";

// CREATE THE STORE AND MERGE WITH ROOT REDUCER
// const store = createStore(
//   rootReducers,
//   window.__REDUX_DEVTOOLS_EXTENSIONS__ && window.__REDUX_DEVTOOLS_EXTENSION__()
// );

// THE PROVIDER TAG MAKES THE STORE AVAILABLE FOR USE GLOBALLY IN YOUR APP
ReactDOM.createRoot(document.getElementById("root")).render(
  <Provider store={store}>
    <Router>
      <App />
    </Router>
  </Provider>
);
