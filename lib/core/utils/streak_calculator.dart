/// Streak calculation utility for consecutive on-time sleep records.

class StreakCalculator {
  StreakCalculator._();

  /// Calculate current consecutive on-time streak.
  static int calculateCurrentStreak(List<dynamic> records) {
    if (records.isEmpty) return 0;

    // Sort by date descending (most recent first)
    final sorted = List.from(records)
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    for (final record in sorted) {
      if (record.wentToBedOnTime == true) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Calculate longest ever on-time streak.
  static int calculateLongestStreak(List<dynamic> records) {
    if (records.isEmpty) return 0;

    // Sort by date ascending
    final sorted = List.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));

    int longest = 0;
    int current = 0;
    for (final record in sorted) {
      if (record.wentToBedOnTime == true) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 0;
      }
    }
    return longest;
  }

  /// Calculate success rate (% of on-time records).
  static double calculateSuccessRate(List<dynamic> records) {
    if (records.isEmpty) return 0.0;
    final onTime = records.where((r) => r.wentToBedOnTime == true).length;
    return onTime / records.length;
  }

  /// Calculate average bedtime variance in minutes.
  static int calculateAverageVariance(List<dynamic> records) {
    if (records.isEmpty) return 0;

    final variances = <int>[];
    for (final record in records) {
      if (record.actualBedtime != null && record.plannedBedtime != null) {
        final planned = _parseMinutes(record.plannedBedtime);
        final actual = _parseMinutes(record.actualBedtime);
        variances.add((actual - planned).abs());
      }
    }

    if (variances.isEmpty) return 0;
    return (variances.reduce((a, b) => a + b) / variances.length).round();
  }

  static int _parseMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
