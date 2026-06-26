// TheMealDB base URL (free test API key "1")
const MEALDB_BASE = 'https://www.themealdb.com/api/json/v1/1';

// ===========================================
// Get Categories — List all meal categories
// ===========================================
const getCategories = async (req, res) => {
  try {
    const response = await fetch(`${MEALDB_BASE}/categories.php`);
    const data = await response.json();
    res.json(data);
  } catch (err) {
    console.error('Fetch categories error:', err.message);
    res.status(500).json({ message: 'Failed to fetch categories' });
  }
};

// ===========================================
// Search Recipes — Search by name keyword
// ===========================================
const searchRecipes = async (req, res) => {
  try {
    const { q } = req.query;
    if (!q) {
      return res.status(400).json({ message: 'Search query is required' });
    }

    const response = await fetch(`${MEALDB_BASE}/search.php?s=${encodeURIComponent(q)}`);
    const data = await response.json();
    res.json(data);
  } catch (err) {
    console.error('Search recipes error:', err.message);
    res.status(500).json({ message: 'Failed to search recipes' });
  }
};

// ===========================================
// Filter Recipes — Filter by category
// ===========================================
const filterByCategory = async (req, res) => {
  try {
    const { c } = req.query;
    if (!c) {
      return res.status(400).json({ message: 'Category is required' });
    }

    const response = await fetch(`${MEALDB_BASE}/filter.php?c=${encodeURIComponent(c)}`);
    const data = await response.json();
    res.json(data);
  } catch (err) {
    console.error('Filter recipes error:', err.message);
    res.status(500).json({ message: 'Failed to filter recipes' });
  }
};

// ===========================================
// Random Recipe — Get a random meal
// ===========================================
const getRandomRecipe = async (req, res) => {
  try {
    const response = await fetch(`${MEALDB_BASE}/random.php`);
    const data = await response.json();
    res.json(data);
  } catch (err) {
    console.error('Random recipe error:', err.message);
    res.status(500).json({ message: 'Failed to fetch random recipe' });
  }
};

// ===========================================
// Get Recipe By ID — Full recipe details
// ===========================================
const getRecipeById = async (req, res) => {
  try {
    const { id } = req.params;
    const response = await fetch(`${MEALDB_BASE}/lookup.php?i=${id}`);
    const data = await response.json();

    if (!data.meals) {
      return res.status(404).json({ message: 'Recipe not found' });
    }

    res.json(data);
  } catch (err) {
    console.error('Lookup recipe error:', err.message);
    res.status(500).json({ message: 'Failed to fetch recipe details' });
  }
};

module.exports = {
  getCategories,
  searchRecipes,
  filterByCategory,
  getRandomRecipe,
  getRecipeById,
};
