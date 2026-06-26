const express = require('express');
const authMiddleware = require('../middleware/auth');
const { getFavorites, addFavorite, removeFavorite } = require('../controllers/favoriteController');

const router = express.Router();

// All favorites routes require authentication
router.use(authMiddleware);

// GET /api/favorites — Get user's saved recipes
router.get('/', getFavorites);

// POST /api/favorites — Save a recipe
router.post('/', addFavorite);

// DELETE /api/favorites/:recipeId — Remove a favorite
router.delete('/:recipeId', removeFavorite);

module.exports = router;
