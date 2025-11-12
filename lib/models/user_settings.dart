/// User settings model for storing default game configuration values
class UserSettings {
  final String defaultCourtName;
  final double defaultCourtRate;
  final double defaultShuttleCockPrice;
  final bool divideCourtEqually;

  UserSettings({
    required this.defaultCourtName,
    required this.defaultCourtRate,
    required this.defaultShuttleCockPrice,
    required this.divideCourtEqually,
  });

  /// Create default settings
  factory UserSettings.defaults() {
    return UserSettings(
      defaultCourtName: 'Court 1',
      defaultCourtRate: 400.0,
      defaultShuttleCockPrice: 150.0,
      divideCourtEqually: true,
    );
  }
}
