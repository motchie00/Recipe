const Favorite = require('../models/Favorite');

// ===========================================
// Get Favorites — User's saved recipes
// ===========================================
const getFavorites = async (req, res) => {
  try {
    const favorites = await Favorite.find({ userId: req.user.id })
      .sort({ createdAt: -1 });
    res.json({ favorites });
  } catch (err) {
    console.error('Get favorites error:', err.message);
    res.status(500).json({ message: 'Failed to fetch favorites' });
  }
};

// ===========================================
// Add Favorite — Save a recipe
// ===========================================
const addFavorite = async (req, res) => {
  try {
    const { recipeId, recipeName, recipeImage, recipeCategory, recipeArea } = req.body;

    if (!recipeId || !recipeName) {
      return res.status(400).json({ message: 'Recipe ID and name are required' });
    }

    // Check if already favorited
    const existing = await Favorite.findOne({
      userId: req.user.id,
      recipeId,
    });

    if (existing) {
      return res.status(400).json({ message: 'Recipe already saved' });
    }

    const favorite = new Favorite({
      userId: req.user.id,
      recipeId,
      recipeName,
      recipeImage: recipeImage || '',
      recipeCategory: recipeCategory || '',
      recipeArea: recipeArea || '',
    });

    await favorite.save();
    res.status(201).json({ message: 'Recipe saved', favorite });
  } catch (err) {
    // Handle duplicate key error gracefully
    if (err.code === 11000) {
      return res.status(400).json({ message: 'Recipe already saved' });
    }
    console.error('Save favorite error:', err.message);
    res.status(500).json({ message: 'Failed to save recipe' });
  }
};

// ===========================================
// Remove Favorite — Delete a saved recipe
// ===========================================
const removeFavorite = async (req, res) => {
  try {
    const result = await Favorite.findOneAndDelete({
      userId: req.user.id,
      recipeId: req.params.recipeId,
    });

    if (!result) {
      return res.status(404).json({ message: 'Favorite not found' });
    }

    res.json({ message: 'Recipe removed from favorites' });
  } catch (err) {
    console.error('Delete favorite error:', err.message);
    res.status(500).json({ message: 'Failed to remove favorite' });
  }
};

module.exports = { getFavorites, addFavorite, removeFavorite };
