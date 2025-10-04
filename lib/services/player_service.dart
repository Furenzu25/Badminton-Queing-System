import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/badminton_level.dart';

/// Centralized business logic for player management
/// This service is the single source of truth for all player operations
/// Following single responsibility principle - handles all player CRUD operations
class PlayerService extends ChangeNotifier {
  // In-memory storage for players (can be replaced with database later)
  final List<Player> _players = [];

  /// Get all players (read-only)
  List<Player> get players => List.unmodifiable(_players);

  /// Get player count
  int get playerCount => _players.length;

  /// Create a new player
  /// Returns the created player
  Player createPlayer({
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
    // Validate that min level is not greater than max level
    if (!_isValidLevelRange(minLevel, minStrength, maxLevel, maxStrength)) {
      throw ArgumentError('Minimum level cannot be greater than maximum level');
    }

    final player = Player.create(
      nickname: nickname.trim(),
      fullName: fullName.trim(),
      contactNumber: contactNumber.trim(),
      email: email.trim(),
      address: address.trim(),
      remarks: remarks.trim(),
      minLevel: minLevel,
      minStrength: minStrength,
      maxLevel: maxLevel,
      maxStrength: maxStrength,
    );

    _players.add(player);
    notifyListeners();
    return player;
  }

  /// Update an existing player
  /// Returns the updated player or null if not found
  Player? updatePlayer(
    String playerId, {
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
    final index = _players.indexWhere((p) => p.id == playerId);
    if (index == -1) return null;

    // Validate that min level is not greater than max level
    if (!_isValidLevelRange(minLevel, minStrength, maxLevel, maxStrength)) {
      throw ArgumentError('Minimum level cannot be greater than maximum level');
    }

    final updatedPlayer = _players[index].copyWith(
      nickname: nickname.trim(),
      fullName: fullName.trim(),
      contactNumber: contactNumber.trim(),
      email: email.trim(),
      address: address.trim(),
      remarks: remarks.trim(),
      minLevel: minLevel,
      minStrength: minStrength,
      maxLevel: maxLevel,
      maxStrength: maxStrength,
    );

    _players[index] = updatedPlayer;
    notifyListeners();
    return updatedPlayer;
  }

  /// Delete a player by ID
  /// Returns true if deleted, false if not found
  bool deletePlayer(String playerId) {
    final index = _players.indexWhere((p) => p.id == playerId);
    if (index == -1) return false;

    _players.removeAt(index);
    notifyListeners();
    return true;
  }

  /// Get a player by ID
  Player? getPlayerById(String playerId) {
    try {
      return _players.firstWhere((p) => p.id == playerId);
    } catch (e) {
      return null;
    }
  }

  /// Search players by nickname or full name
  /// Case-insensitive search
  List<Player> searchPlayers(String query) {
    if (query.trim().isEmpty) {
      return players;
    }

    final lowerQuery = query.toLowerCase().trim();
    return _players.where((player) {
      return player.nickname.toLowerCase().contains(lowerQuery) ||
          player.fullName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Check if nickname already exists (excluding a specific player ID)
  bool isNicknameExists(String nickname, {String? excludePlayerId}) {
    return _players.any(
      (player) =>
          player.nickname.toLowerCase() == nickname.toLowerCase().trim() &&
          player.id != excludePlayerId,
    );
  }

  /// Check if email already exists (excluding a specific player ID)
  bool isEmailExists(String email, {String? excludePlayerId}) {
    return _players.any(
      (player) =>
          player.email.toLowerCase() == email.toLowerCase().trim() &&
          player.id != excludePlayerId,
    );
  }

  /// Get players by skill level range
  List<Player> getPlayersByLevel(BadmintonLevel level) {
    return _players.where((player) {
      return (player.minLevel.index <= level.index &&
          player.maxLevel.index >= level.index);
    }).toList();
  }

  /// Validate that the level range is valid
  /// Min level should not be greater than max level
  bool _isValidLevelRange(
    BadmintonLevel minLevel,
    SkillStrength minStrength,
    BadmintonLevel maxLevel,
    SkillStrength maxStrength,
  ) {
    if (minLevel.index > maxLevel.index) {
      return false;
    }

    // If same level, check strength
    if (minLevel.index == maxLevel.index &&
        minStrength.index > maxStrength.index) {
      return false;
    }

    return true;
  }

  /// Clear all players (useful for testing)
  void clearAllPlayers() {
    _players.clear();
    notifyListeners();
  }
}
