import React from "react";
import ListDetail from "./ListDetail";

const items = [
  {
    id: 1,
    title: "Sunset at the Beach",
    description:
      "A beautiful sunset at the beach with waves crashing onto the shore.",
    imageUrl: "https://example.com/images/sunset.jpg",
    category: "Nature",
    likes: 120,
    comments: [
      { user: "Alice", text: "Stunning view!" },
      { user: "Bob", text: "Wish I were there!" },
    ],
  },
  {
    id: 2,
    title: "Mountain Hike",
    description:
      "A challenging hike up the Rocky Mountains with breathtaking views.",
    imageUrl: "https://example.com/images/mountain.jpg",
    category: "Adventure",
    likes: 200,
    comments: [
      { user: "Charlie", text: "Amazing experience!" },
      { user: "Dave", text: "On my bucket list." },
    ],
  },
  {
    id: 3,
    title: "City Skyline",
    description:
      "The skyline of a bustling city at night with skyscrapers illuminated.",
    imageUrl: "https://example.com/images/skyline.jpg",
    category: "Urban",
    likes: 150,
    comments: [
      { user: "Eve", text: "Love the lights!" },
      { user: "Frank", text: "Great shot!" },
    ],
  },
  {
    id: 4,
    title: "Forest Path",
    description:
      "A serene path through a dense forest with sunlight filtering through the trees.",
    imageUrl: "https://example.com/images/forest.jpg",
    category: "Nature",
    likes: 180,
    comments: [
      { user: "Grace", text: "So peaceful." },
      { user: "Hank", text: "I want to go for a walk here." },
    ],
  },
  {
    id: 5,
    title: "Desert Dunes",
    description: "Expansive sand dunes under a clear blue sky in the desert.",
    imageUrl: "https://example.com/images/desert.jpg",
    category: "Adventure",
    likes: 130,
    comments: [
      { user: "Ivy", text: "Looks like a great place for an adventure!" },
      { user: "Jack", text: "Reminds me of my trip to the Sahara." },
    ],
  },
];

function ListArrays() {
  return (
    <div>
      {items.map((item) => (
        <ListDetail key={item.id} item={item} />
      ))}
    </div>
  );
}

export default ListArrays;
