// auth.js
const VALID_AUTH_TOKEN = "mysecrettoken"; // Example hardcoded token

// Simple authentication middleware
const authenticate = async (req, res, next) => {
  try {
    const token = req.header('Authorization');
    if (!token) {
      return res.status(401).json({ error: 'Authorization token is required' });
    }

    if (token !== `Bearer ${VALID_AUTH_TOKEN}`) {
      return res.status(403).json({ error: 'Invalid token' });
    }

    next(); // Proceed to the next middleware or route handler
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = authenticate;
