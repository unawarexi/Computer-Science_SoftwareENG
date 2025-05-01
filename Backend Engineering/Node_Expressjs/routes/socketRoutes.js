const express = require('express');
const router = express.Router();

// Example: Health check or socket info endpoint
router.get('/health', (req, res) => {
  res.status(200).json({ success: true, message: 'Socket server is running' });
});

module.exports = router;
