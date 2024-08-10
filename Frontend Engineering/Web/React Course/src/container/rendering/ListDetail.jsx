import React from "react";

function ListDetail(item) {
  return (
    <div>
      <div>
        <img src={item.imageUrl} alt={item.title} />
        <h1>Title: {item.title}</h1>
      </div>
      <section>
        <p>DESC: {item.description}</p>
        <div>
          <p>Category: {item.category}</p>
          <div>
            <p>Likes: {item.likes}</p>
          </div>
        </div>
        <p>
          Comments:
          {item.comments.map((comment, index) => (
            <ul key={index}>
              <li>
                <strong>{comment.user}</strong>
              </li>
              <li>{comment.text}</li>
            </ul>
          ))}
        </p>
      </section>
    </div>
  );
}

export default ListDetail;
