import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../services/feedback_service.dart';
import '../providers/feedback_provider.dart';

/// Screen where users can submit feedback (rating, category, comments).
class FeedbackScreen extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  const FeedbackScreen({super.key, this.onMenuPressed});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  
  String _selectedCategory = 'Suggestion';
  int _rating = 5;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Suggestion',
    'Feature Request',
    'Bug Report',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedbackProvider>().loadFeedback();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FeedbackService.submitFeedback(
        category: _selectedCategory,
        rating: _rating,
        comments: _commentController.text.trim(),
      );
    } catch (_) {
      // Ignore connection errors/404 for mock/dev environment
    }

    // Mock response delay for smooth feel
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 56,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Thank You!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your feedback helps us make Pinas Sarap better for everyone.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceColor.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  _commentController.clear();
                  setState(() {
                    _rating = 5;
                    _selectedCategory = 'Suggestion';
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.onMenuPressed != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: widget.onMenuPressed,
              )
            : null,
        title: const Text('Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF8D432C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share your thoughts!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Have a suggestion, found a bug, or want to request a new feature? Let us know!',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Category Title
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              // Category Choice Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = category);
                          }
                        },
                        selectedColor:
                            AppTheme.primaryColor.withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.onSurfaceColor.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.outlineColor,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),

              // Rating Title
              Text(
                'Rate your experience',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // Interactive Star Rating Row
              Row(
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return IconButton(
                    icon: Icon(
                      starValue <= _rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() => _rating = starValue);
                    },
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Comment Box Title
              Text(
                'Comments & Suggestions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              // Comment Field
              TextFormField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tell us more details...',
                  hintStyle: TextStyle(
                    color: AppTheme.onSurfaceColor.withValues(alpha: 0.4),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.outlineColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.outlineColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some details';
                  }
                  if (value.trim().length < 5) {
                    return 'Comments must be at least 5 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, Color(0xFF8D432C)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Consumer<FeedbackProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.feedback.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Feedback',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No feedback submitted yet. Your past feedback will appear here once submitted.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.onSurfaceColor.withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Feedback',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...provider.feedback.map((item) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.outlineColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['category'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: List.generate(5, (index) {
                                      final starValue = index + 1;
                                      return Icon(
                                        starValue <= (item['rating'] ?? 0)
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['comments'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.onSurfaceColor.withValues(alpha: 0.8),
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['createdAt'] != null
                                    ? DateTime.parse(item['createdAt']).toLocal().toString().split('.')[0]
                                    : '',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.onSurfaceColor.withValues(alpha: 0.5),
                                    ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
