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

  /// Create a copy of the player with updated fields
  Player copyWith({
    String? nickname,
    String? fullName,
    String? contactNumber,
    String? email,
    String? address,
    String? remarks,
    BadmintonLevel? minLevel,
    SkillStrength? minStrength,
    BadmintonLevel? maxLevel,
    SkillStrength? maxStrength,
  }) {
    return Player(
      id: id,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      remarks: remarks ?? this.remarks,
      minLevel: minLevel ?? this.minLevel,
      minStrength: minStrength ?? this.minStrength,
      maxLevel: maxLevel ?? this.maxLevel,
      maxStrength: maxStrength ?? this.maxStrength,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
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

  /// Convert player to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'fullName': fullName,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'remarks': remarks,
      'minLevel': minLevel.index,
      'minStrength': minStrength.index,
      'maxLevel': maxLevel.index,
      'maxStrength': maxStrength.index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create player from map
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as String,
      nickname: map['nickname'] as String,
      fullName: map['fullName'] as String,
      contactNumber: map['contactNumber'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      remarks: map['remarks'] as String,
      minLevel: BadmintonLevel.fromIndex(map['minLevel'] as int),
      minStrength: SkillStrength.fromIndex(map['minStrength'] as int),
      maxLevel: BadmintonLevel.fromIndex(map['maxLevel'] as int),
      maxStrength: SkillStrength.fromIndex(map['maxStrength'] as int),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
