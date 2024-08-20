import "./App.css";

import { Routes, Route } from "react-router-dom";
import AxiosList from "./React-Apis/AxiosList";
import IndexComponent from "./React-Redux/components/IndexComponent";
import { ContextProvider } from "./context/ContextProvider";
import HomePage from "./Introduction/Hello";
import Component from "./components/BasicComponents/Components";
import User from "./components/propComponents/User";

function App() {
  return (
    <ContextProvider>
      <Routes>
        {/* ------------- BASIC ROUTING ----------------------- */}
        <Route path="/" element={<HomePage />} />
        <Route path="/component" element={<Component />} />
        <Route path="/props" element={<User />} />

        <Route path="/axios" element={<AxiosList />} />
        <Route path="/redux" element={<IndexComponent />} />
      </Routes>
    </ContextProvider>
  );
}

export default App;
