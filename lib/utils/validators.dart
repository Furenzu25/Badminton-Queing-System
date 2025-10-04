/// Centralized validation utilities for form inputs
/// Following single responsibility principle - each validator has one purpose
class Validators {
  /// Private constructor to prevent instantiation
  Validators._();

  /// Validates that a field is not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // RFC 5322 simplified email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates phone number (numeric only)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }

    // Remove common phone formatting characters
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Contact number must contain only digits';
    }

    if (cleaned.length < 7 || cleaned.length > 15) {
      return 'Contact number must be between 7 and 15 digits';
    }

    return null;
  }

  /// Validates nickname (alphanumeric and spaces)
  static String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nickname is required';
    }

    if (value.trim().length < 2) {
      return 'Nickname must be at least 2 characters';
    }

    if (value.trim().length > 20) {
      return 'Nickname must not exceed 20 characters';
    }

    return null;
  }

  /// Validates full name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }

    if (value.trim().length > 50) {
      return 'Full name must not exceed 50 characters';
    }

    return null;
  }

  /// Validates address
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }

    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters';
    }

    return null;
  }
}
