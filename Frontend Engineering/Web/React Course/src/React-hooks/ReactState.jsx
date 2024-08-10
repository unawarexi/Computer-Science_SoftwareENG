import React, { useState } from "react";
import UserState from "../components/stateComponents/UserState";

/**
 * State is a representation of data that changes over time.
 * It stores data within the React components and is an inbuilt object.
 *
 * @returns State
 */

function ReactState() {
  const [users, setUsers] = useState([
    {
      id: 1,
      username: "paul",
      email: "paul@gmail.com",
    },
    {
      id: 2,
      username: "gift",
      email: "gift@gmail.com",
    },
  ]);

  return (
    <div>
      {users.map((user) => (
        <UserState key={user.id} user={user} setUsers={setUsers} />
      ))}
    </div>
  );
}

export default ReactState;
