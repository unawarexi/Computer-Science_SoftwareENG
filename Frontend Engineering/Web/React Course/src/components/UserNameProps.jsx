import React from "react";

function UserNameProps({ age, marital, job, gender }) {
  return (
    <div>
      <p>
        this user is {age} and is {marital}, and {job} he has a {gender} kid
      </p>
    </div>
  );
}

export default UserNameProps;
