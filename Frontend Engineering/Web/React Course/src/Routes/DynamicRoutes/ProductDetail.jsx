import React from "react";
import { Link, Outlet, useParams } from "react-router-dom";
import Images from "../../assets/Image.js";

const ProductDetail = () => {
  const { productId } = useParams();

  // Example product data (This would typically come from a server or context)
  const productList = [
    {
      id: 1,
      name: "Product 1",
      desc: "This is an awesome product.",
      image: Images.image1,
      likes: 120,
      comments: [
        "Great product!",
        "Loved it!",
        "Highly recommend!",
        "Value for money.",
      ],
      specs: { color: "Red", size: "Large", weight: "1kg" },
    },
    {
      id: 2,
      name: "Product 2",
      desc: "This product is great.",
      image: Images.image2,
      likes: 85,
      comments: [
        "Not bad",
        "Good quality.",
        "Would buy again.",
        "Decent for the price.",
      ],
      specs: { color: "Blue", size: "Medium", weight: "0.8kg" },
    },
    {
      id: 3,
      name: "Product 3",
      desc: "You'll love this product.",
      image: Images.image3,
      likes: 200,
      comments: [
        "Amazing!",
        "Exceeded expectations.",
        "Best purchase ever.",
        "5 stars!",
      ],
      specs: { color: "Green", size: "Small", weight: "0.5kg" },
    },
    {
      id: 4,
      name: "Product 4",
      desc: "A must-have product.",
      image: Images.profilePic,
      likes: 150,
      comments: [
        "Very useful",
        "Sturdy and reliable.",
        "Worth every penny.",
        "A++",
      ],
      specs: { color: "Black", size: "Large", weight: "1.2kg" },
    },
    {
      id: 5,
      name: "Product 5",
      desc: "Top-rated product.",
      image: Images.profilePic2,
      likes: 175,
      comments: [
        "Impressive!",
        "Great design.",
        "Top quality.",
        "Highly satisfied.",
      ],
      specs: { color: "White", size: "Medium", weight: "0.9kg" },
    },
  ];

  // Find the current product by ID
  const product = productList.find((p) => p.id === parseInt(productId));

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-3xl font-bold mb-4">{product.name}</h1>
      <img
        src={product.image}
        alt={product.name}
        className="w-full h-64 object-cover mb-4"
      />
      <p className="text-gray-700 mb-4">{product.desc}</p>

      <div className="mb-4">
        <span className="font-semibold">Likes: </span>
        <span className="text-blue-500">{product.likes}</span>
      </div>

      <div className="mb-4">
        <h2 className="text-xl font-semibold mb-2">Specifications:</h2>
        <ul className="list-disc ml-6">
          <li>Color: {product.specs.color}</li>
          <li>Size: {product.specs.size}</li>
          <li>Weight: {product.specs.weight}</li>
        </ul>
      </div>

      <div className="mb-4">
        <h2 className="text-xl font-semibold mb-2">Comments:</h2>
        <ul className="list-disc ml-6">
          {product.comments.map((comment, index) => (
            <li key={index} className="text-gray-600">
              {comment}
            </li>
          ))}
        </ul>
      </div>

      <Link to={`/reviews`} className="text-blue-500 hover:underline">
        View Reviews
      </Link>

      <Outlet />
    </div>
  );
};

export default ProductDetail;
