export default function Conditional() {
  const user = "VERIFIED";

  //---------- using switch case
  switch (user) {
    case "VERIFIED":
      return (
        <div>
          <h1>welcome user</h1>
        </div>
      );
    case "NOT VERIFIED":
      return (
        <div>
          <h1> kindly register</h1>
        </div>
      );
    case "ACCOUNT_DISABLED":
      return (
        <div>
          <h1>account is not active</h1>
        </div>
      );

    default:
      return (
        <div>
          <h1> contact help center</h1>
        </div>
      );
      break;
  }

  // --------- using if else statement
  //  if (user === "NOT VERIFIED") {
  //   return (
  //     <div>
  //       <h1> kindly register</h1>
  //     </div>
  //   );
  // } else if (user === "VERIFIED") {
  //   return (
  //     <div>
  //       <h1> welcome user</h1>
  //     </div>
  //   );
  // } else if (user === "NOT ACTIVE") {
  //   return (
  //     <div>
  //       <h1>Account has been disabled</h1>
  //     </div>
  //   );
  // } else {
  //   return (
  //     <div>
  //       <h1>user does not exist</h1>
  //     </div>
  //   );
  // }

  
}

export default function conditionalBoolen() {
  const isAuthenticated = false;

  if (isAuthenticated) {
    return (
      <div>
        <h1>welcome</h1>
      </div>
    );
  } else if (!isAuthenticated) {
    return (
      <div>
        <h1>please login</h1>
      </div>
    );
  }
}

export default function ConditionalTernary() {
  const isAuthenticated = true;

  return (
    <div>
      {/* ternary operators */}
      {isAuthenticated ? "" : ""}

      {isAuthenticated ? (
        <div>
          <h1> the account is authenticated </h1>
        </div>
      ) : (
        <div> the account is not authenticated</div>
      )}
    </div>
  );
}


