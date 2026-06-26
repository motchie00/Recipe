const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

// Import routes
const authRoutes = require('./routes/auth');
const recipeRoutes = require('./routes/recipes');
const favoriteRoutes = require('./routes/favorites');
const customRecipeRoutes = require('./routes/customRecipes');

const app = express();
const PORT = process.env.PORT || 3000;

// ===========================================
// Middleware Configuration
// ===========================================
app.use(cors());
app.use(express.json());

// ===========================================
// MongoDB Connection (inline — no config folder)
// ===========================================
mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('✅ Connected to MongoDB successfully');
  })
  .catch((err) => {
    console.error('❌ MongoDB connection error:', err.message);
    process.exit(1);
  });

// Handle connection events after initial connection
mongoose.connection.on('error', (err) => {
  console.error('MongoDB runtime error:', err.message);
});

mongoose.connection.on('disconnected', () => {
  console.log('⚠️  MongoDB disconnected');
});

// ===========================================
// Route Mounting
// ===========================================
app.use('/api/auth', authRoutes);
app.use('/api/recipes', recipeRoutes);
app.use('/api/favorites', favoriteRoutes);
app.use('/api/custom-recipes', customRecipeRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Recipe App API is running' });
});

// ===========================================
// Global Error Handler
// ===========================================
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err.stack);
  res.status(500).json({ message: 'Internal server error' });
});

// ===========================================
// Start Server
// ===========================================
app.listen(PORT, () => {
  console.log(`🚀 Recipe App server running on port ${PORT}`);
});
