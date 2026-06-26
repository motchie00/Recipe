import 'dart:convert';

/// User model for authentication and profile display.
class User {
  final String id;
  final String fullName;
  final String email;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.createdAt,
  });

  /// Parse from backend JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Encode user to JSON string for SharedPreferences
  String encode() => jsonEncode(toJson());

  /// Decode user from JSON string
  factory User.decode(String encoded) {
    return User.fromJson(jsonDecode(encoded));
  }
}
