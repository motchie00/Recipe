import 'package:flutter/material.dart';
import '../services/feedback_service.dart';

class FeedbackProvider with ChangeNotifier {
  List<Map<String, dynamic>> _feedback = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get feedback => _feedback;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFeedback() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _feedback = await FeedbackService.getUserFeedback();
    } catch (e) {
      _feedback = [];
      _error = 'Failed to load feedback';
    }

    _isLoading = false;
    notifyListeners();
  }
}
