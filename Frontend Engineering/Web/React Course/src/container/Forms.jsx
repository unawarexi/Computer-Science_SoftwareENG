import React, { useState } from "react";

/**
 *  the act of using state to hold the data from the form is - data binding
 *  the handleSubmit handles submission of form values
 * the handleChange keeps track and updates changes in the input field
 *
 * formData is the current state and setForm data is set to change values
 * useState is a react hook and builtin functions
 *
 * on submit or on" anything" are regarded as eventHandlers
 * ${} are known as template literals they're use for binding data
 * @returns Forms
 */

function UserForm() {
  // this is an array destructuring for state
  const [formData, setFormData] = useState({
    username: "",
    password: "",
    extraField1: "",
    extraField2: "",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    console.log(e.target.value);
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle form submission
    console.log("Form data:", formData);
    alert(
      `Username: ${formData.username}, 
      Password: ${formData.password}, 
      Extra Field 1: ${formData.extraField1}, 
      Extra Field 2: ${formData.extraField2}`
    );
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>
          Username:
          <input
            type="text"
            name="username"
            value={formData.username}
            onChange={handleChange}
            // onKeyDown={(e) => {
            //   console.log(e.target.value);
            // }}
          />
        </label>
      </div>
      <div>
        <label>
          Password:
          <input
            type="password"
            name="password"
            value={formData.password}
            onChange={handleChange}
          />
        </label>
      </div>
      <div>
        <label>
          Extra Field 1:
          <input
            type="text"
            name="extraField1"
            value={formData.extraField1}
            onChange={handleChange}
          />
        </label>
      </div>
      <div>
        <label>
          Extra Field 2:
          <input
            type="text"
            name="extraField2"
            value={formData.extraField2}
            onChange={handleChange}
          />
        </label>
      </div>
      <button type="submit">Submit</button>
    </form>
  );
}

export default UserForm;
