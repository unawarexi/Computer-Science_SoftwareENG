const express = require('express');

const cors = require('cors');
const {connectDB}  = require('./config/dbconfig');

//Routes importing
const userRoutes = require('./routes/userRoutes');
const productRoutes = require('./routes/productRoutes')

const app = express();

app.use(cors());
app.use(express.json());

//Dotenv configuration
require('dotenv').config(); 
const MONGO_URL = process.env.MONGO_URL;
const PORT = process.env.PORT ;


//Working with routes
app.use("/api/users", userRoutes);
app.use("/api/products", productRoutes)

app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`);
    connectDB(MONGO_URL);
})