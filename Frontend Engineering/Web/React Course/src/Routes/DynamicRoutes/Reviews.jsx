import React from "react";
import { Link, useParams } from "react-router-dom";

const Reviews = () => {
  const { productId } = useParams();
  const reviewList = [
    { id: 1, title: "Review 1" },
    { id: 2, title: "Review 2" },
    { id: 3, title: "Review 3" },
  ];

  return (
    <div className="mt-4">
      <h2 className="text-xl font-semibold mb-4">
        Reviews for Product ID: {productId}
      </h2>
      <ul>
        {reviewList.map((review) => (
          <li key={review.id} className="mb-2">
            <Link
              to={`/reviews/${review.id}`}
              className="text-blue-500 hover:underline"
            >
              {review.title}
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default Reviews;
