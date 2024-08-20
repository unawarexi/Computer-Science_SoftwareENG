import React from "react";

const CommentReviewPage = ({ params }: { params: { productsID: string } }) => {
  return <h1>Details of product {params.productsID}</h1>;
};

export default CommentReviewPage;
