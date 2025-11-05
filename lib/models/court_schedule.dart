/// Court schedule model representing a single court reservation
class CourtSchedule {
  final String courtNumber;
  final DateTime startTime;
  final DateTime endTime;

  CourtSchedule({
    required this.courtNumber,
    required this.startTime,
    required this.endTime,
  });

  /// Get duration in hours
  double get durationInHours {
    final duration = endTime.difference(startTime);
    return duration.inMinutes / 60.0;
  }

  /// Get formatted time range (e.g., "6:00 PM - 9:00 PM")
  String get timeRange {
    final startFormatted = _formatTime(startTime);
    final endFormatted = _formatTime(endTime);
    return '$startFormatted - $endFormatted';
  }

  /// Get formatted date (e.g., "Nov 3, 2025")
  String get dateFormatted {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[startTime.month - 1]} ${startTime.day}, ${startTime.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'courtNumber': courtNumber,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  /// Create from Map
  factory CourtSchedule.fromMap(Map<String, dynamic> map) {
    return CourtSchedule(
      courtNumber: map['courtNumber'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
    );
  }
}

