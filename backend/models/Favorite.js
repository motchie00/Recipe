const mongoose = require('mongoose');

// ===========================================
// Favorite Schema — stores user's saved recipes
// ===========================================
const favoriteSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  recipeId: {
    type: String,
    required: [true, 'Recipe ID is required'],
  },
  recipeName: {
    type: String,
    required: [true, 'Recipe name is required'],
  },
  recipeImage: {
    type: String,
    default: '',
  },
  recipeCategory: {
    type: String,
    default: '',
  },
  recipeArea: {
    type: String,
    default: '',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Compound index to prevent duplicate favorites per user
favoriteSchema.index({ userId: 1, recipeId: 1 }, { unique: true });

module.exports = mongoose.model('Favorite', favoriteSchema);
