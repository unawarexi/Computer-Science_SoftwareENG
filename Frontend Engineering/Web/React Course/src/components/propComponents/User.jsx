import React from "react";
import UserDetails from "./UserDetails";
import Images from "../../assets/Image.js";

// Sample user data
const user = {
  name: "John Doe",
  email: "john.doe@example.com",
  profilePic: Images.profilePic,
  bio: "Software developer with a passion for building user-friendly applications. Enjoys working with React and exploring new technologies.",
  location: "San Francisco, CA",
  hobbies: ["Coding", "Hiking", "Photography"],
  social: {
    twitter: "https://twitter.com/johndoe",
    linkedin: "https://linkedin.com/in/johndoe",
    github: "https://github.com/johndoe",
  },
};

const User = () => {
  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <h1 className="text-3xl font-bold text-center mb-8">User Profile</h1>
      <UserDetails
        name={user.name}
        email={user.email}
        profilePic={user.profilePic}
        bio={user.bio}
        location={user.location}
        hobbies={user.hobbies}
        social={user.social}
      />
    </div>
  );
};

export default User;
