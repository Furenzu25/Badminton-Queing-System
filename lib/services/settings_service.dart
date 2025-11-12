import 'package:flutter/foundation.dart';
import '../models/user_settings.dart';

/// Service for managing user settings
/// Centralized business logic for settings operations
/// Following single responsibility principle - handles all settings operations
class SettingsService extends ChangeNotifier {
  UserSettings _settings = UserSettings.defaults();

  /// Get current settings (read-only)
  UserSettings get settings => _settings;

  /// Update settings
  /// Note: Assumes input is already validated by Validators class
  void updateSettings({
    required String defaultCourtName,
    required double defaultCourtRate,
    required double defaultShuttleCockPrice,
    required bool divideCourtEqually,
  }) {
    _settings = UserSettings(
      defaultCourtName: defaultCourtName.trim(),
      defaultCourtRate: defaultCourtRate,
      defaultShuttleCockPrice: defaultShuttleCockPrice,
      divideCourtEqually: divideCourtEqually,
    );

    notifyListeners();
  }

  /// Reset settings to defaults
  void resetToDefaults() {
    _settings = UserSettings.defaults();
    notifyListeners();
  }

  /// Load settings from storage (placeholder for future persistence)
  /// For now, just uses defaults
  void loadSettings() {
    // TODO: Load from shared preferences or database when needed
    _settings = UserSettings.defaults();
    notifyListeners();
  }

  /// Save settings to storage (placeholder for future persistence)
  void saveSettings() {
    // TODO: Save to shared preferences or database when needed
    notifyListeners();
  }
}

