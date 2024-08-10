import "./App.css";
import SecondPropComp from "./components/SecondPropComp";
// import { Routes, Route } from "react-router-dom";
// import UserProfile from "./components/UserProfileProps";
// import ReactState from "./React-hooks/ReactState";
import UserState from "./components/stateComponents/UserState";
import UserProfile from "./components/UserProfileProps";
// import ListArrays from "./container/rendering/ListArrays";
import ListDetail from "./container/rendering/ListDetail";
import { Routes, Route } from "react-router-dom";
import Home from "./Layout/Home";
import ReactRouter from "./React-Navigation/ReactRouter";
import DynamicRoute from "./React-Navigation/DynamicRoute";
import AxiosList from "./React-Apis/AxiosList";
import IndexComponent from "./React-Redux/components/IndexComponent";

function App() {
  return (
    <div className="">
      {/* <UserState /> */}
      {/* <ListDetail /> */}
      {/* <UserProfile />
      <SecondPropComp /> */}

      <Routes>
        <Route path="/" element={<ReactRouter />} />
        <Route path="/auth" element={<DynamicRoute />} />
        <Route path="/axios" element={<AxiosList />} />
        <Route path="/redux" element={<IndexComponent />} />
      </Routes>
    </div>

    // <div className="App justify-center items-center w-screen min-h-screen flex">
    //   <Routes>
    //     <Route path="/" element={<UserProfile />} />

    //     {/* <Route path="/cake" element={<CakeContainer />} />
    //     <Route path="/cakesec" element={<HooksCake />} />
    //     <Route path="/login" element={<Login />} />
    //     <Route path="/forms" element={<React_forms />} /> */}
    //   </Routes>
    // </div>
  );
}

export default App;
