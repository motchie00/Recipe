const mongoose = require('mongoose');

// ===========================================
// CustomRecipe Schema — stores user-created recipes
// Each recipe is scoped to the user who created it
// ===========================================
const ingredientSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    measure: { type: String, default: '', trim: true },
  },
  { _id: false }
);

const customRecipeSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
  },
  name: {
    type: String,
    required: [true, 'Recipe name is required'],
    trim: true,
  },
  category: {
    type: String,
    default: 'General',
    trim: true,
  },
  area: {
    type: String,
    default: 'Homemade',
    trim: true,
  },
  instructions: {
    type: String,
    required: [true, 'Instructions are required'],
    trim: true,
  },
  // Stored as a base64 string or empty
  thumbnail: {
    type: String,
    default: '',
  },
  ingredients: {
    type: [ingredientSchema],
    default: [],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Compound index for efficient user-scoped lookups
customRecipeSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model('CustomRecipe', customRecipeSchema);
