const express = require('express');
const authMiddleware = require('../middleware/auth');
const { submitFeedback, getUserFeedback } = require('../controllers/feedbackController');

const router = express.Router();

router.use(authMiddleware);

router.post('/', submitFeedback);
router.get('/', getUserFeedback);

module.exports = router;
