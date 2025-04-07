import React from "react";
import { Link } from "react-router-dom";
import Images from "../../assets/Image";
import { FaStar } from "react-icons/fa";

const Products = () => {
  const productList = [
    {
      id: 1,
      name: "Product 1",
      desc: "This is an awesome product.",
      rating: 4.5,
    },
    { id: 2, name: "Product 2", desc: "This product is great.", rating: 4.0 },
    {
      id: 3,
      name: "Product 3",
      desc: "You'll love this product.",
      rating: 5.0,
    },
    { id: 4, name: "Product 4", desc: "A must-have product.", rating: 4.2 },
    { id: 5, name: "Product 5", desc: "Top-rated product.", rating: 4.8 },
  ];

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-3xl font-bold mb-8 text-center">Our Products</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
        {productList.map((product) => (
          <div
            key={product.id}
            className="bg-white shadow-md rounded-lg overflow-hidden"
          >
            <img
              src={Images.image2}
              alt={product.name}
              className="w-full h-48 object-cover"
            />
            <div className="p-4">
              <h2 className="text-xl font-semibold mb-2">{product.name}</h2>
              <p className="text-gray-700 mb-4">{product.desc}</p>
              <div className="flex items-center mb-4">
                {[...Array(5)].map((_, index) => (
                  <FaStar
                    key={index}
                    className={`mr-1 ${
                      index < Math.floor(product.rating)
                        ? "text-yellow-500"
                        : "text-gray-300"
                    }`}
                  />
                ))}
                <span className="ml-2 text-gray-600">{product.rating}</span>
              </div>
              <Link
                to={`/products/${product.id}`}
                className="block text-center bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded transition duration-200"
              >
                Details
              </Link>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Products;
