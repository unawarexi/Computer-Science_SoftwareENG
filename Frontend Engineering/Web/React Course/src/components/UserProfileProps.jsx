import React from "react";
import UserNameProps from "./UserNameProps";

/**
 * props are only called in the child components
 * child components can only be  modified from the parent component
 * it can call a number, a non-primitive, a Boolean, even a function
 *
 * @param {*} props
 * @returns age and marital
 */

const UserProfile = (props) => {
  return (
    <div className="flex font-semibold text-center items-center justify-center bg-black/10 h-[50%] text-2xl gap-x-4">
      <h1> UserProfile:</h1>{" "}
      <UserNameProps age={30} marital=" married" job="software engineer" />
    </div>
  );
};

export default UserProfile;
