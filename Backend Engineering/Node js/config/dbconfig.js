const mongoose = require("mongoose");
const MONGO_URL = process.env.MONGO_URL

const connectDB = async (mongo_URL) => {
  try {
    await mongoose.connect(mongo_URL); // Directly await the connection
    console.log(`MongoDB connected successfully`);
  } catch (error) {
    console.error(`MongoDB connection Error: ${error}`); // Use console.error for errors
    process.exit(1);
  }
};

module.exports = { connectDB };


// const mongoose = require('mongoose');

// const connectDB = async(url) => {
//     try {
//         await mongoose.connect(url);
//         console.log("Connected to MongoDB")
//     } catch (error) {
//         console.log("Some error occured while connecting to DB");
//         console.log(error);
//     }
// }

// module.exports = { connectDB };
