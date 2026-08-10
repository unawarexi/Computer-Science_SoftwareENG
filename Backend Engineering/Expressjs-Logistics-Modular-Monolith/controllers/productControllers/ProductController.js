const modelProduct = require("../models/ProductModel"); // Ensure this points to the correct model

const ProductController = {
    
    // Get all products
    getAllProducts: async (req, res) => {
        try {
            const products = await modelProduct.find();
            res.json({status: "ok", products});
        } catch (error) {
            console.error("there's an exception", error);
            res.status(500).json({error: "An error occurred while fetching products."});
        }
    },

    // Get a single product by ID
    getProductById: async (req, res) => {
        try {
            const product = await modelProduct.findById(req.params.id);
            if (!product) {
                return res.status(404).json({error: "Product not found"});
            }
            res.json({status: "ok", product});
        } catch (error) {
            console.error("there's an exception", error);
            res.status(500).json({error: "An error occurred while fetching the product."});
        }
    },

    // Add a new product
    createProduct: async (req, res) => {
        try {
            const newProduct = new modelProduct(req.body); // assuming req.body contains product data
            const savedProduct = await newProduct.save();
            res.status(201).json({status: "ok", product: savedProduct});
        } catch (error) {
            console.error("there's an exception", error);
            res.status(500).json({error: "An error occurred while creating the product."});
        }
    },

    // Update a product by ID
    updateProduct: async (req, res) => {
        try {
            const updatedProduct = await modelProduct.findByIdAndUpdate(req.params.id, req.body, {
                new: true, // return the updated product
                runValidators: true // ensure the updates conform to the model schema
            });
            if (!updatedProduct) {
                return res.status(404).json({error: "Product not found"});
            }
            res.json({status: "ok", product: updatedProduct});
        } catch (error) {
            console.error("there's an exception", error);
            res.status(500).json({error: "An error occurred while updating the product."});
        }
    },

    // Delete a product by ID
    deleteProduct: async (req, res) => {
        try {
            const deletedProduct = await modelProduct.findByIdAndDelete(req.params.id);
            if (!deletedProduct) {
                return res.status(404).json({error: "Product not found"});
            }
            res.json({status: "ok", message: "Product deleted successfully"});
        } catch (error) {
            console.error("there's an exception", error);
            res.status(500).json({error: "An error occurred while deleting the product."});
        }
    }
};

module.exports = ProductController;
