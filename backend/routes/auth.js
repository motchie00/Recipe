const express = require('express');
const { body } = require('express-validator');
const authMiddleware = require('../middleware/auth');
const { register, login, getProfile } = require('../controllers/authController');

const router = express.Router();

// POST /api/auth/register — Create new user
router.post(
  '/register',
  [
    body('fullName')
      .trim()
      .notEmpty().withMessage('Full name is required')
      .isLength({ min: 2 }).withMessage('Full name must be at least 2 characters'),
    body('email')
      .trim()
      .isEmail().withMessage('Please enter a valid email'),
    body('password')
      .isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
    body('confirmPassword')
      .custom((value, { req }) => {
        if (value !== req.body.password) {
          throw new Error('Passwords do not match');
        }
        return true;
      }),
  ],
  register
);

// POST /api/auth/login — Authenticate user
router.post(
  '/login',
  [
    body('email').trim().isEmail().withMessage('Please enter a valid email'),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  login
);

// GET /api/auth/me — Get current user profile
router.get('/me', authMiddleware, getProfile);

module.exports = router;
