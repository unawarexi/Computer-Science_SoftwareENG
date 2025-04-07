import React from "react";

// Component to display the details of a single item
function ArrayObjectsDetail({ item }) {
  return (
    <div className="bg-white rounded-lg shadow-lg  shadow-red-500 p-6 mb-6">
      {/* Image and Title */}
      <div className="flex items-center mb-4">
        <img
          src={item.imageUrl}
          alt={item.title}
          className="w-24 h-24 object-cover rounded-full border-2 border-blue-500"
        />
        <h1 className="text-2xl font-bold ml-4">{item.title}</h1>
      </div>

      {/* Description */}
      <section>
        <p className="text-gray-700 mb-4">{item.description}</p>

        {/* Category and Likes */}
        <div className="flex justify-between items-center mb-4">
          <p className="text-sm font-semibold text-gray-500">
            Category: <span className="text-blue-500">{item.category}</span>
          </p>
          <p className="text-sm font-semibold text-gray-500">
            Likes: <span className="text-red-500">{item.likes}</span>
          </p>
        </div>

        {/* Comments */}
        <p className="text-sm font-semibold text-gray-500 mb-2">Comments:</p>
        <ul className="pl-4 list-disc">
          {item.comments.map((comment, index) => (
            <li key={index} className="text-gray-700 mb-1">
              <strong>{comment.user}: </strong> {comment.text}
            </li>
          ))}
        </ul>
      </section>
    </div>
  );
}

export default ArrayObjectsDetail;
