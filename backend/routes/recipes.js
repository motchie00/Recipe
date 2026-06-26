const express = require('express');
const {
  getCategories,
  searchRecipes,
  filterByCategory,
  getRandomRecipe,
  getRecipeById,
} = require('../controllers/recipeController');

const router = express.Router();

// GET /api/recipes/categories — List all categories
router.get('/categories', getCategories);

// GET /api/recipes/search?q=keyword — Search by name
router.get('/search', searchRecipes);

// GET /api/recipes/filter?c=category — Filter by category
router.get('/filter', filterByCategory);

// GET /api/recipes/random — Get random meal
router.get('/random', getRandomRecipe);

// GET /api/recipes/:id — Get full recipe details (must be LAST)
router.get('/:id', getRecipeById);

module.exports = router;
