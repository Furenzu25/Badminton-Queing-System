import 'package:flutter/foundation.dart';
import '../models/game.dart';
import '../models/court_schedule.dart';

/// Service for managing games
/// Centralized business logic for game CRUD operations
/// Following single responsibility principle - handles all game operations
class GameService extends ChangeNotifier {
  // In-memory storage for games (can be replaced with database later)
  final List<Game> _games = [];

  /// Get all games (read-only)
  List<Game> get games => List.unmodifiable(_games);

  /// Create a new game
  /// Returns the created game
  Game createGame({
    required String title,
    required String courtName,
    required List<CourtSchedule> schedules,
    required double courtRate,
    required double shuttleCockPrice,
    required bool divideCourtEqually,
    List<String>? playerIds,
  }) {
    // Validate inputs
    if (courtName.trim().isEmpty) {
      throw ArgumentError('Court name cannot be empty');
    }
    if (schedules.isEmpty) {
      throw ArgumentError('At least one schedule is required');
    }
    if (courtRate <= 0) {
      throw ArgumentError('Court rate must be greater than 0');
    }
    if (shuttleCockPrice <= 0) {
      throw ArgumentError('Shuttle cock price must be greater than 0');
    }

    // Validate schedules
    for (final schedule in schedules) {
      if (schedule.startTime.isAfter(schedule.endTime) ||
          schedule.startTime.isAtSameMomentAs(schedule.endTime)) {
        throw ArgumentError('End time must be after start time');
      }
    }

    final game = Game.create(
      title: title.trim(),
      courtName: courtName.trim(),
      schedules: schedules,
      courtRate: courtRate,
      shuttleCockPrice: shuttleCockPrice,
      divideCourtEqually: divideCourtEqually,
      playerIds: playerIds,
    );

    _games.add(game);
    notifyListeners();
    return game;
  }

  /// Update an existing game
  /// Returns the updated game or null if not found
  Game? updateGame(
    String gameId, {
    required String title,
    required String courtName,
    required List<CourtSchedule> schedules,
    required double courtRate,
    required double shuttleCockPrice,
    required bool divideCourtEqually,
    List<String>? playerIds,
  }) {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index == -1) return null;

    // Validate inputs
    if (courtName.trim().isEmpty) {
      throw ArgumentError('Court name cannot be empty');
    }
    if (schedules.isEmpty) {
      throw ArgumentError('At least one schedule is required');
    }
    if (courtRate <= 0) {
      throw ArgumentError('Court rate must be greater than 0');
    }
    if (shuttleCockPrice <= 0) {
      throw ArgumentError('Shuttle cock price must be greater than 0');
    }

    // Validate schedules
    for (final schedule in schedules) {
      if (schedule.startTime.isAfter(schedule.endTime) ||
          schedule.startTime.isAtSameMomentAs(schedule.endTime)) {
        throw ArgumentError('End time must be after start time');
      }
    }

    final existing = _games[index];

    final updatedGame = Game(
      id: existing.id,
      title: title.trim(),
      courtName: courtName.trim(),
      schedules: schedules,
      courtRate: courtRate,
      shuttleCockPrice: shuttleCockPrice,
      divideCourtEqually: divideCourtEqually,
      playerIds: playerIds ?? existing.playerIds,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    _games[index] = updatedGame;
    notifyListeners();
    return updatedGame;
  }

  /// Delete a game by ID
  /// Returns true if deleted, false if not found
  bool deleteGame(String gameId) {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index == -1) return false;

    _games.removeAt(index);
    notifyListeners();
    return true;
  }

  /// Search games by title or date
  /// Case-insensitive search
  List<Game> searchGames(String query) {
    if (query.trim().isEmpty) {
      return games;
    }

    final lowerQuery = query.toLowerCase().trim();
    return _games.where((game) {
      final titleMatch = game.displayTitle.toLowerCase().contains(lowerQuery);
      final dateMatch = game.schedules.any(
        (schedule) => schedule.dateFormatted.toLowerCase().contains(lowerQuery),
      );
      return titleMatch || dateMatch;
    }).toList();
  }

  /// Add a player to a game
  bool addPlayerToGame(String gameId, String playerId) {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index == -1) return false;

    final game = _games[index];
    if (game.playerIds.contains(playerId)) {
      return false; // Player already in game
    }

    final updatedPlayerIds = List<String>.from(game.playerIds)..add(playerId);

    _games[index] = Game(
      id: game.id,
      title: game.title,
      courtName: game.courtName,
      schedules: game.schedules,
      courtRate: game.courtRate,
      shuttleCockPrice: game.shuttleCockPrice,
      divideCourtEqually: game.divideCourtEqually,
      playerIds: updatedPlayerIds,
      createdAt: game.createdAt,
      updatedAt: DateTime.now(),
    );

    notifyListeners();
    return true;
  }

  /// Remove a player from a game
  bool removePlayerFromGame(String gameId, String playerId) {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index == -1) return false;

    final game = _games[index];
    if (!game.playerIds.contains(playerId)) {
      return false; // Player not in game
    }

    final updatedPlayerIds = List<String>.from(game.playerIds)
      ..remove(playerId);

    _games[index] = Game(
      id: game.id,
      title: game.title,
      courtName: game.courtName,
      schedules: game.schedules,
      courtRate: game.courtRate,
      shuttleCockPrice: game.shuttleCockPrice,
      divideCourtEqually: game.divideCourtEqually,
      playerIds: updatedPlayerIds,
      createdAt: game.createdAt,
      updatedAt: DateTime.now(),
    );

    notifyListeners();
    return true;
  }

  /// Clear all games (for testing/seeding)
  void clearAllGames() {
    _games.clear();
    notifyListeners();
  }
}

