import React, { useState, useEffect } from "react";

const gotoschool = () => {
  console.log("i am in school");
};

gotoschool();

// UserState component receives a user object and a setUsers function as props
function UserState(user, setUsers) {
  // State to toggle between editing mode
  const [isEditing, setIsEditing] = useState(false);

  // State to manage the form data for manipulating the user details
  const [formData, setFormData] = useState({
    username: "",
    email: "",
  });

  // Effect to set initial formData based on user prop
  useEffect(() => {
    if (user) {
      setFormData({
        username: user.username,
        email: user.email,
      });
    }
  }, [user]);

  // Handler for form input changes
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevFormData) => ({
      ...prevFormData,
      [name]: value,
    }));
  };

  // Handler for saving changes
  const handleSave = () => {
    setUsers((currentUsers) =>
      currentUsers.map((currentUser) =>
        currentUser.id === user.id
          ? { ...currentUser, ...formData }
          : currentUser
      )
    );

    // Since we're saving and no longer editing, turn this to false
    setIsEditing(false);
  };

  // Handler for deleting the user
  const handleDelete = () => {
    setUsers((currentUsers) =>
      currentUsers.filter((currentUser) => currentUser.id !== user.id)
    );
  };

  if (!user) {
    return <div>Loading...</div>; // Fallback UI if user is undefined
  }

  return (
    <div className=" grid grid-rows-1 w-full bg-gray-100 px-2 py-4 justify-center items-center gap-y-4 ">
      <div>
        <p className="font-semibold text-2xl text-rose-500">ID:</p>
        <span>{user.id}</span>
      </div>
      {/* =============  THIS IS FOR THE USERNAME INPUT FIELD ================== */}
      <div>
        <p className="font-bold">USERNAME:</p>
        {isEditing ? (
          <input
            name="username"
            id="username"
            value={formData.username}
            onChange={handleInputChange()}
            className="py-2 px-2 w-full rounded-md border-2 border-black"
          />
        ) : (
          <span>{user.username}</span>
        )}
      </div>

      {/* =============  THIS IS FOR THE EMAIL INPUT FIELD ================== */}
      <div>
        <p className="font-bold">Email:</p>
        {isEditing ? (
          <input
            name="email"
            id="email"
            value={formData.email}
            onChange={handleInputChange}
            className="py-2 px-2 w-full rounded-md border-2 border-black"
          />
        ) : (
          <span>{user.email}</span>
        )}
      </div>

      {/* =============  THIS IS FOR THE BUTTONS ================== */}
      <div className="px-4 bg-slate-500 py-2 font-semibold text-white text-center rounded-md">
        <button
          className=""
          onClick={() => setIsEditing((currentState) => !currentState)}
        >
          {isEditing ? "Cancel" : "Edit"}
        </button>
      </div>
      {isEditing && (
        <div className="px-4 bg-blue-500 py-2 font-semibold text-white text-center rounded-md">
          <button onClick={handleSave}>Save</button>
        </div>
      )}
      <div className="px-4 bg-red-500 py-2 font-semibold text-white text-center rounded-md">
        <button onClick={handleDelete}>Delete</button>
      </div>
    </div>
  );
}

export default UserState;
