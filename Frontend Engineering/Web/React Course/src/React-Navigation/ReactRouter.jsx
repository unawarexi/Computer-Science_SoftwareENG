import React from "react";
import { Link } from "react-router-dom";

function ReactRouter() {
  return (
    <div>
      <Link to="/auth">
        <p className="border-2 bg-blue-500">click</p>
      </Link>
    </div>
  );
}

export default ReactRouter;
