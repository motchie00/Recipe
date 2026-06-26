const express = require('express');
const authMiddleware = require('../middleware/auth');
const {
  getCustomRecipes,
  getCustomRecipeById,
  addCustomRecipe,
  deleteCustomRecipe,
  updateCustomRecipe,
} = require('../controllers/customRecipeController');

const router = express.Router();

// All custom recipe routes require authentication
router.use(authMiddleware);

// GET /api/custom-recipes — Get all custom recipes for the logged-in user
router.get('/', getCustomRecipes);

// GET /api/custom-recipes/:id — Get a single recipe by ID
router.get('/:id', getCustomRecipeById);

// POST /api/custom-recipes — Create a new custom recipe
router.post('/', addCustomRecipe);

// PUT /api/custom-recipes/:id — Update a custom recipe
router.put('/:id', updateCustomRecipe);

// DELETE /api/custom-recipes/:id — Delete a recipe
router.delete('/:id', deleteCustomRecipe);

module.exports = router;
