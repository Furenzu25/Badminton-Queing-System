/// Enum representing badminton skill levels
enum BadmintonLevel {
  beginner,
  intermediate,
  levelG,
  levelF,
  levelE,
  levelD,
  openPlayer;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case BadmintonLevel.beginner:
        return 'Beginner';
      case BadmintonLevel.intermediate:
        return 'Intermediate';
      case BadmintonLevel.levelG:
        return 'Level G';
      case BadmintonLevel.levelF:
        return 'Level F';
      case BadmintonLevel.levelE:
        return 'Level E';
      case BadmintonLevel.levelD:
        return 'Level D';
      case BadmintonLevel.openPlayer:
        return 'Open Player';
    }
  }

  /// Get level from index
  static BadmintonLevel fromIndex(int index) {
    if (index < 0 || index >= BadmintonLevel.values.length) {
      return BadmintonLevel.beginner;
    }
    return BadmintonLevel.values[index];
  }
}

/// Enum representing skill strength within a level
enum SkillStrength {
  weak,
  mid,
  strong;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case SkillStrength.weak:
        return 'Weak';
      case SkillStrength.mid:
        return 'Mid';
      case SkillStrength.strong:
        return 'Strong';
    }
  }

  /// Get strength from index
  static SkillStrength fromIndex(int index) {
    if (index < 0 || index >= SkillStrength.values.length) {
      return SkillStrength.mid;
    }
    return SkillStrength.values[index];
  }
}
