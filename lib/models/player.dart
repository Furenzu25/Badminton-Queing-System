import 'package:uuid/uuid.dart';
import 'badminton_level.dart';

/// Player model representing a badminton player profile
class Player {
  final String id;
  final String nickname;
  final String fullName;
  final String contactNumber;
  final String email;
  final String address;
  final String remarks;
  final BadmintonLevel minLevel;
  final SkillStrength minStrength;
  final BadmintonLevel maxLevel;
  final SkillStrength maxStrength;
  final DateTime createdAt;
  final DateTime updatedAt;

  Player({
    required this.id,
    required this.nickname,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.minLevel,
    required this.minStrength,
    required this.maxLevel,
    required this.maxStrength,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new player with generated ID and timestamps
  factory Player.create({
    required String nickname,
    required String fullName,
    required String contactNumber,
    required String email,
    required String address,
    required String remarks,
    required BadmintonLevel minLevel,
    required SkillStrength minStrength,
    required BadmintonLevel maxLevel,
    required SkillStrength maxStrength,
  }) {
    final now = DateTime.now();
    return Player(
      id: const Uuid().v4(),
      nickname: nickname,
      fullName: fullName,
      contactNumber: contactNumber,
      email: email,
      address: address,
      remarks: remarks,
      minLevel: minLevel,
      minStrength: minStrength,
      maxLevel: maxLevel,
      maxStrength: maxStrength,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Get formatted skill level range as a string
  String get skillLevelRange {
    final minLevelStr = '${minLevel.displayName} (${minStrength.displayName})';
    final maxLevelStr = '${maxLevel.displayName} (${maxStrength.displayName})';

    if (minLevel == maxLevel && minStrength == maxStrength) {
      return minLevelStr;
    }

    return '$minLevelStr → $maxLevelStr';
  }
}
