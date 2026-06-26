const jwt = require('jsonwebtoken');

// ===========================================
// JWT Authentication Middleware
// Verifies token and attaches user ID to req
// ===========================================
const authMiddleware = (req, res, next) => {
  try {
    // Get token from Authorization header
    const authHeader = req.header('Authorization');

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'No token provided. Access denied.' });
    }

    const token = authHeader.replace('Bearer ', '');

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { id: decoded.userId };
    next();
  } catch (err) {
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token expired. Please login again.' });
    }
    return res.status(401).json({ message: 'Invalid token. Access denied.' });
  }
};

module.exports = authMiddleware;
