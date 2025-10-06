import 'package:flutter/material.dart';
import '../services/player_service.dart';
import 'snackbar_helper.dart';

/// Helper class for player-specific validation logic
/// Centralizes duplicate checking to avoid code repetition
class PlayerValidationHelper {
  /// Private constructor to prevent instantiation
  PlayerValidationHelper._();

  /// Validates that nickname and email are unique
  /// Returns true if validation passes, false otherwise
  /// Automatically shows appropriate SnackBar messages
  static bool validateUniqueness(
    BuildContext context,
    PlayerService playerService,
    String nickname,
    String email, {
    String? excludePlayerId,
  }) {
    // Check for duplicate nickname
    if (playerService.isNicknameExists(
      nickname,
      excludePlayerId: excludePlayerId,
    )) {
      SnackBarHelper.showWarning(
        context,
        'Nickname "$nickname" already exists',
      );
      return false;
    }

    // Check for duplicate email
    if (playerService.isEmailExists(email, excludePlayerId: excludePlayerId)) {
      SnackBarHelper.showWarning(context, 'Email "$email" already exists');
      return false;
    }

    return true;
  }
}
