const express = require('express');

const cors = require('cors');
const {connectDB}  = require('./config/dbconfig');

//Routes importing
const userRoutes = require('./routes/userRoutes/userRoutes');
const productRoutes = require('./routes/productRoutes/productRoutes')
const memberRoutes = require("./routes/memberRoutes/memberRoutes")

const app = express();

app.use(cors());
app.use(express.json());

//Dotenv configuration
require('dotenv').config(); 
const MONGO_URL = process.env.MONGO_URL;
const PORT = process.env.PORT ;


//Working with routes
app.use("/api", userRoutes);
app.use("/api", productRoutes)
app.use("/api", memberRoutes)

app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`);
    connectDB(MONGO_URL);
})