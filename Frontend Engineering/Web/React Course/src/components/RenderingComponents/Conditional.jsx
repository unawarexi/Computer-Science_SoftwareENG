import React, { useState } from "react";

// Function to handle switch case logic
function renderSwitchCase(user) {
  switch (user) {
    case "VERIFIED":
      return (
        <div className="bg-green-100 p-4 rounded-lg shadow-lg">
          <h2 className="text-lg font-semibold text-green-700">
            Welcome, user
          </h2>
        </div>
      );
    case "NOT VERIFIED":
      return (
        <div className="bg-red-100 p-4 rounded-lg shadow-lg">
          <h2 className="text-lg font-semibold text-red-700">
            Kindly register
          </h2>
        </div>
      );
    case "ACCOUNT_DISABLED":
      return (
        <div className="bg-red-100 p-4 rounded-lg shadow-lg">
          <h2 className="text-lg font-semibold text-red-700">
            Account is not active
          </h2>
        </div>
      );
    default:
      return (
        <div className="bg-red-100 p-4 rounded-lg shadow-lg">
          <h2 className="text-lg font-semibold text-red-700">
            Contact help center
          </h2>
        </div>
      );
  }
}

// Function to handle if-else logic
function renderIfElse(user) {
  if (user === "NOT VERIFIED") {
    return (
      <div className="bg-red-100 p-4 rounded-lg shadow-lg">
        <h2 className="text-lg font-semibold text-red-700">Kindly register</h2>
      </div>
    );
  } else if (user === "VERIFIED") {
    return (
      <div className="bg-green-100 p-4 rounded-lg shadow-lg">
        <h2 className="text-lg font-semibold text-green-700">Welcome, user</h2>
      </div>
    );
  } else if (user === "NOT ACTIVE") {
    return (
      <div className="bg-red-100 p-4 rounded-lg shadow-lg">
        <h2 className="text-lg font-semibold text-red-700">
          Account has been disabled
        </h2>
      </div>
    );
  } else {
    return (
      <div className="bg-red-100 p-4 rounded-lg shadow-lg">
        <h2 className="text-lg font-semibold text-red-700">
          User does not exist
        </h2>
      </div>
    );
  }
}

// Function to handle boolean logic
function renderConditionalBoolean(isAuthenticated) {
  if (isAuthenticated) {
    return (
      <div className="bg-green-100 p-4 rounded-lg shadow-lg">
        <h2 className="text-lg font-semibold text-green-700">Welcome</h2>
      </div>
    );
  } else {
    return (
      <div className="bg-red-100 p-4 rounded-lg shadow-lg">
        <h2 className="text-lg font-semibold text-red-700">Please login</h2>
      </div>
    );
  }
}

// Function to handle ternary logic
function renderConditionalTernary(isAuthenticated) {
  return (
    <div className="bg-green-100 p-4 rounded-lg shadow-lg">
      {/* Ternary operator to check authentication */}
      {isAuthenticated ? (
        <h2 className="text-lg font-semibold text-green-700">
          The account is authenticated
        </h2>
      ) : (
        <h2 className="text-lg font-semibold text-red-700">
          The account is not authenticated
        </h2>
      )}
    </div>
  );
}

// Main component to render all examples
export default function Conditional() {
  const user = "NOT VERIFIED";
  const isAuthenticated = true;

  return (
    <div className="container mx-auto p-6 space-y-8">
      {/* Switch Case Example */}
      <section>
        <h1 className="text-3xl font-bold mb-2">Using Switch Case</h1>
        <hr className="border-gray-300 mb-4" />
        {renderSwitchCase(user)}
      </section>

      {/* If Else Example */}
      <section>
        <h1 className="text-3xl font-bold mb-2">Using If Else</h1>
        <hr className="border-gray-300 mb-4" />
        {renderIfElse(user)}
      </section>

      {/* Conditional Boolean Example */}
      <section>
        <h1 className="text-3xl font-bold mb-2">Using Conditional Boolean</h1>
        <hr className="border-gray-300 mb-4" />
        {renderConditionalBoolean(isAuthenticated)}
      </section>

      {/* Ternary Operator Example */}
      <section>
        <h1 className="text-3xl font-bold mb-2">Using Ternary Operator</h1>
        <hr className="border-gray-300 mb-4" />
        {renderConditionalTernary(isAuthenticated)}
      </section>
    </div>
  );
}
