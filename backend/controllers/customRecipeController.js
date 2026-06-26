const CustomRecipe = require('../models/CustomRecipe');

// ===========================================
// Get all custom recipes for the logged-in user
// ===========================================
const getCustomRecipes = async (req, res) => {
  try {
    const recipes = await CustomRecipe.find({ userId: req.user.id })
      .sort({ createdAt: -1 })
      .lean();

    res.json({ recipes });
  } catch (err) {
    console.error('Get custom recipes error:', err.message);
    res.status(500).json({ message: 'Failed to fetch custom recipes' });
  }
};

// ===========================================
// Get a single custom recipe by ID (user-scoped)
// ===========================================
const getCustomRecipeById = async (req, res) => {
  try {
    const recipe = await CustomRecipe.findOne({
      _id: req.params.id,
      userId: req.user.id,
    }).lean();

    if (!recipe) {
      return res.status(404).json({ message: 'Recipe not found' });
    }

    res.json({ recipe });
  } catch (err) {
    console.error('Get custom recipe by ID error:', err.message);
    res.status(500).json({ message: 'Failed to fetch recipe' });
  }
};

// ===========================================
// Create a new custom recipe
// ===========================================
const addCustomRecipe = async (req, res) => {
  try {
    const { name, category, area, instructions, thumbnail, ingredients } = req.body;

    if (!name || !name.trim()) {
      return res.status(400).json({ message: 'Recipe name is required' });
    }
    if (!instructions || !instructions.trim()) {
      return res.status(400).json({ message: 'Instructions are required' });
    }

    const recipe = new CustomRecipe({
      userId: req.user.id,
      name: name.trim(),
      category: category?.trim() || 'General',
      area: area?.trim() || 'Homemade',
      instructions: instructions.trim(),
      thumbnail: thumbnail || '',
      ingredients: Array.isArray(ingredients) ? ingredients : [],
    });

    await recipe.save();

    res.status(201).json({ message: 'Recipe created', recipe });
  } catch (err) {
    console.error('Add custom recipe error:', err.message);
    res.status(500).json({ message: 'Failed to create recipe' });
  }
};

// ===========================================
// Delete a custom recipe (only owner can delete)
// ===========================================
const deleteCustomRecipe = async (req, res) => {
  try {
    const result = await CustomRecipe.findOneAndDelete({
      _id: req.params.id,
      userId: req.user.id,
    });

    if (!result) {
      return res.status(404).json({ message: 'Recipe not found or not authorized' });
    }

    res.json({ message: 'Recipe deleted' });
  } catch (err) {
    console.error('Delete custom recipe error:', err.message);
    res.status(500).json({ message: 'Failed to delete recipe' });
  }
};

// ===========================================
// Update an existing custom recipe (only owner can update)
// ===========================================
const updateCustomRecipe = async (req, res) => {
  try {
    const { name, category, area, instructions, thumbnail, ingredients } = req.body;

    if (!name || !name.trim()) {
      return res.status(400).json({ message: 'Recipe name is required' });
    }
    if (!instructions || !instructions.trim()) {
      return res.status(400).json({ message: 'Instructions are required' });
    }

    const updatedRecipe = await CustomRecipe.findOneAndUpdate(
      { _id: req.params.id, userId: req.user.id },
      {
        name: name.trim(),
        category: category?.trim() || 'General',
        area: area?.trim() || 'Homemade',
        instructions: instructions.trim(),
        thumbnail: thumbnail || '',
        ingredients: Array.isArray(ingredients) ? ingredients : [],
      },
      { new: true }
    );

    if (!updatedRecipe) {
      return res.status(404).json({ message: 'Recipe not found or not authorized' });
    }

    res.json({ message: 'Recipe updated', recipe: updatedRecipe });
  } catch (err) {
    console.error('Update custom recipe error:', err.message);
    res.status(500).json({ message: 'Failed to update recipe' });
  }
};

module.exports = {
  getCustomRecipes,
  getCustomRecipeById,
  addCustomRecipe,
  deleteCustomRecipe,
  updateCustomRecipe,
};
