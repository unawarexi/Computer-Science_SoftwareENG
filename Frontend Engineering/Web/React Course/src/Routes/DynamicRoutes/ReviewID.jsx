import React from "react";
import { useParams } from "react-router-dom";

const ReviewDetail = () => {
  const { reviewId } = useParams();

  return (
    <div className="mt-4">
      <h3 className="text-lg font-medium">Review Detail - ID: {reviewId}</h3>
      <p className="mt-2">
        This is the detailed view for the review with ID {reviewId}.
      </p>
    </div>
  );
};

export default ReviewDetail;
