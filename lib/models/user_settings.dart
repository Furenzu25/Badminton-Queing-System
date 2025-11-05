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

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'defaultCourtName': defaultCourtName,
      'defaultCourtRate': defaultCourtRate,
      'defaultShuttleCockPrice': defaultShuttleCockPrice,
      'divideCourtEqually': divideCourtEqually,
    };
  }

  /// Create from Map
  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      defaultCourtName: map['defaultCourtName'] as String,
      defaultCourtRate: (map['defaultCourtRate'] as num).toDouble(),
      defaultShuttleCockPrice: (map['defaultShuttleCockPrice'] as num).toDouble(),
      divideCourtEqually: map['divideCourtEqually'] as bool,
    );
  }
}

