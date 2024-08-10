import React from "react";
import UserNameProps from "./UserNameProps";

function SecondPropComp() {
  return (
    <div className="flex font-semibold text-center items-center justify-center bg-black/10 h-[50%] text-2xl gap-x-4">
      <UserNameProps
        age={25}
        marital="single"
        job="self employed"
        gender="female"
      />
    </div>
  );
}

export default SecondPropComp;
