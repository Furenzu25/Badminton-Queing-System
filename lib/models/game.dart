import 'package:uuid/uuid.dart';
import 'court_schedule.dart';

/// Game model representing a badminton game session
class Game {
  final String id;
  final String title;
  final String courtName;
  final List<CourtSchedule> schedules;
  final double courtRate;
  final double shuttleCockPrice;
  final bool divideCourtEqually;
  final List<String> playerIds; // List of player IDs in this game
  final DateTime createdAt;
  final DateTime updatedAt;

  Game({
    required this.id,
    required this.title,
    required this.courtName,
    required this.schedules,
    required this.courtRate,
    required this.shuttleCockPrice,
    required this.divideCourtEqually,
    required this.playerIds,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new game with generated ID and timestamps
  factory Game.create({
    required String title,
    required String courtName,
    required List<CourtSchedule> schedules,
    required double courtRate,
    required double shuttleCockPrice,
    required bool divideCourtEqually,
    List<String>? playerIds,
  }) {
    final now = DateTime.now();
    return Game(
      id: const Uuid().v4(),
      title: title,
      courtName: courtName,
      schedules: schedules,
      courtRate: courtRate,
      shuttleCockPrice: shuttleCockPrice,
      divideCourtEqually: divideCourtEqually,
      playerIds: playerIds ?? [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Get total duration across all schedules in hours
  double get totalDurationInHours {
    return schedules.fold(
      0.0,
      (sum, schedule) => sum + schedule.durationInHours,
    );
  }

  /// Get total court cost
  double get totalCourtCost {
    return courtRate * totalDurationInHours;
  }

  /// Get court cost per player (if divided equally)
  double get courtCostPerPlayer {
    if (!divideCourtEqually || playerIds.isEmpty) {
      return 0.0;
    }
    return totalCourtCost / playerIds.length;
  }

  /// Get display title (use schedule date if title is empty)
  String get displayTitle {
    if (title.trim().isNotEmpty) {
      return title;
    }
    if (schedules.isEmpty) {
      return 'Untitled Game';
    }
    return schedules.first.dateFormatted;
  }

  /// Get formatted schedule summary
  String get scheduleSummary {
    if (schedules.isEmpty) return 'No schedule';
    if (schedules.length == 1) {
      return '${schedules.first.courtNumber}: ${schedules.first.timeRange}';
    }
    return '${schedules.length} courts scheduled';
  }

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'courtName': courtName,
      'schedules': schedules.map((s) => s.toMap()).toList(),
      'courtRate': courtRate,
      'shuttleCockPrice': shuttleCockPrice,
      'divideCourtEqually': divideCourtEqually,
      'playerIds': playerIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from Map
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as String,
      title: map['title'] as String,
      courtName: map['courtName'] as String,
      schedules: (map['schedules'] as List)
          .map((s) => CourtSchedule.fromMap(s as Map<String, dynamic>))
          .toList(),
      courtRate: (map['courtRate'] as num).toDouble(),
      shuttleCockPrice: (map['shuttleCockPrice'] as num).toDouble(),
      divideCourtEqually: map['divideCourtEqually'] as bool,
      playerIds: List<String>.from(map['playerIds'] as List),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
