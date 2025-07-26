import "./App.css";

import { Routes, Route } from "react-router-dom";
import AxiosList from "./React-Apis/AxiosList";
import IndexComponent from "./React-Redux/components/IndexComponent";
import { ContextProvider } from "./context/ContextProvider";
import HomePage from "./Introduction/Hello";
import Component from "./components/BasicComponents/Components";
import User from "./components/propComponents/User";
import ArrayObjectMapping from "./components/RenderingComponents/ArrayObjectsMapping";
import Conditional from "./components/RenderingComponents/Conditional";

import Products from "./Routes/DynamicRoutes/Products";
import ProductDetail from "./Routes/DynamicRoutes/ProductDetail";
import Reviews from "./Routes/DynamicRoutes/Reviews";
import ReviewDetail from "./Routes/DynamicRoutes/ReviewID";

import ExplainHooks from "./hooks/ExplainHooks";

function App() {
  return (
    <ContextProvider>
      <button
        onClick={() => setToggle(!toggle)}
        className="bg-blue-500 text-white font-semibold py-2 px-4 rounded mb-4"
      >
        Toggle Authentication
      </button>
      <Routes>
        {/* ------------- BASIC ROUTING ----------------------- */}
        <Route path="/" element={<HomePage />} />
        <Route path="/component" element={<Component />} />
        <Route path="/props" element={<User />} />
        <Route path="/render" element={<ArrayObjectMapping />} />
        <Route path="/conditional" element={<Conditional />} />

        {/* ----------- conditional routes ----------------------- */}

        <Route
          path="/"
          element={toggle ? <Authentication /> : <Authentication2 />}
        />
        
        {/* -------------  Nested routes -------------- */}
        <Route
          path="/home"
          element={
            <>
              <HeroSection />
              <SecondaryHeroSection />
            </>
          }
        />
        <Route path="/landing" element={<Landing />} />
        <Route path="blog/*" element={<Blog />} />
        <Route path="dashboard/*" element={<Dashboard />} />

        {/* ----------- DYNAMIC ROUTES ---------- */}
        <Route path="/products" element={<Products />} />
        <Route path="/products/:productId" element={<ProductDetail />} />
        <Route path="/reviews" element={<Reviews />} />
        <Route path="/reviews/:reviewId" element={<ReviewDetail />} />

        {/* ----------- HOOKS ------------- */}
        <Route path="/hooks" element={<ExplainHooks />} />
        <Route path="/axios" element={<AxiosList />} />
        <Route path="/redux" element={<IndexComponent />} />
      </Routes>
    </ContextProvider>
  );
}

export default App;
