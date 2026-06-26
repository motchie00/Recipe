const Feedback = require('../models/Feedback');

const submitFeedback = async (req, res) => {
  try {
    const { category, rating, comments } = req.body;

    if (!category || typeof rating !== 'number') {
      return res.status(400).json({ message: 'Category and rating are required.' });
    }

    const feedback = new Feedback({
      userId: req.user.id,
      category,
      rating,
      comments: comments || '',
    });

    await feedback.save();
    res.status(201).json({ message: 'Feedback submitted successfully', feedback });
  } catch (err) {
    console.error('Submit feedback error:', err.message);
    res.status(500).json({ message: 'Failed to submit feedback' });
  }
};

const getUserFeedback = async (req, res) => {
  try {
    const feedback = await Feedback.find({ userId: req.user.id }).sort({ createdAt: -1 });
    res.json({ feedback });
  } catch (err) {
    console.error('Get feedback error:', err.message);
    res.status(500).json({ message: 'Failed to fetch feedback' });
  }
};

module.exports = { submitFeedback, getUserFeedback };
