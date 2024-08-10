// src/pages/User.jsx
import React, { useEffect, useState } from "react";

const User = () => {
  const [user, setUser] = useState(null);

  useEffect(() => {
    const fetchRandomUser = async () => {
      try {
        const response = await fetch("https://randomuser.me/api/");
        const data = await response.json();
        setUser(data.results[0]);
      } catch (error) {
        console.error("Error fetching user:", error);
      }
    };

    fetchRandomUser();
  }, []);

  if (!user) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <h2>{`${user.name.first} ${user.name.last}`}</h2>
      <img
        src={user.picture.large}
        alt={`${user.name.first} ${user.name.last}`}
      />
      <p>{user.email}</p>
      <p>{user.phone}</p>
      <p>{`${user.location.city}, ${user.location.country}`}</p>
    </div>
  );
};

export default User;
