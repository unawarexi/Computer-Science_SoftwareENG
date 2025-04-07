import React from "react";

const UserDetails = ({
  name,
  email,
  profilePic,
  bio,
  location,
  hobbies,
  social,
}) => {
  return (
    <div className="max-w-lg mx-auto bg-white p-6 rounded-lg shadow-lg">
      {/* Profile Picture and Basic Info */}
      <div className="flex items-center mb-6">
        <img
          src={profilePic}
          alt={`${name}'s profile`}
          className="w-24 h-24 object-cover rounded-full border-4 border-blue-500"
        />
        <div className="ml-4">
          <h2 className="text-2xl font-semibold mb-1">{name}</h2>
          <p className="text-gray-600">{email}</p>
          <p className="text-gray-600">{location}</p>
        </div>
      </div>

      {/* Bio */}
      <div className="mb-6">
        <h3 className="text-xl font-semibold mb-2">Bio</h3>
        <p className="text-gray-700">{bio}</p>
      </div>

      {/* Hobbies */}
      <div className="mb-6">
        <h3 className="text-xl font-semibold mb-2">Hobbies</h3>
        <ul className="list-disc list-inside text-gray-700">
          {hobbies.map((hobby, index) => (
            <li key={index}>{hobby}</li>
          ))}
        </ul>
      </div>

      {/* Social Links */}
      <div>
        <h3 className="text-xl font-semibold mb-2">Social Links</h3>
        <div className="flex space-x-4">
          {social.twitter && (
            <a
              href={social.twitter}
              className="text-blue-500 hover:underline"
              target="_blank"
              rel="noopener noreferrer"
            >
              Twitter
            </a>
          )}
          {social.linkedin && (
            <a
              href={social.linkedin}
              className="text-blue-500 hover:underline"
              target="_blank"
              rel="noopener noreferrer"
            >
              LinkedIn
            </a>
          )}
          {social.github && (
            <a
              href={social.github}
              className="text-blue-500 hover:underline"
              target="_blank"
              rel="noopener noreferrer"
            >
              GitHub
            </a>
          )}
        </div>
      </div>
    </div>
  );
};

export default UserDetails;
