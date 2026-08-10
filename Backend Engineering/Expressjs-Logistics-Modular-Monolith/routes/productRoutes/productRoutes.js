const express = require("express")
const productController = require("../../controllers/ProductController");

const router  =  express.Router();

router.get("/products", productController.getAllProducts);
router.get("/products/:id", productController.getProductById);
router.post("/create", productController.createProduct);
router.put("/products/:id", productController.updateProduct);
router.delete("/products/:id", productController.deleteProduct);

module.exports = router;