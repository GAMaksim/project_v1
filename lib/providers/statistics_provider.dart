import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzz/data/models/sleep_record.dart';
import 'package:zzz/data/services/database_service.dart';
import 'package:zzz/core/utils/streak_calculator.dart';
import 'package:zzz/providers/settings_provider.dart';

/// Statistics data model for the UI.
class StatisticsData {
  final List<SleepRecord> records;
  final int totalNights;
  final int onTimeNights;
  final double successRate;
  final int currentStreak;
  final int longestStreak;
  final int averageVariance; // minutes
  final Map<DateTime, bool> calendarData; // date → onTime

  const StatisticsData({
    this.records = const [],
    this.totalNights = 0,
    this.onTimeNights = 0,
    this.successRate = 0.0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.averageVariance = 0,
    this.calendarData = const {},
  });
}

class StatisticsNotifier extends StateNotifier<StatisticsData> {
  final DatabaseService _db;

  StatisticsNotifier(this._db) : super(const StatisticsData()) {
    loadStatistics();
  }

  void loadStatistics() {
    final records = _db.getRecentRecords(30);

    final onTime = records.where((r) => r.wentToBedOnTime == true).length;
    final total = records.length;

    // Build calendar map
    final calendar = <DateTime, bool>{};
    for (final record in records) {
      final dateOnly = DateTime(
        record.date.year,
        record.date.month,
        record.date.day,
      );
      calendar[dateOnly] = record.wentToBedOnTime ?? false;
    }

    state = StatisticsData(
      records: records,
      totalNights: total,
      onTimeNights: onTime,
      successRate: StreakCalculator.calculateSuccessRate(records),
      currentStreak: StreakCalculator.calculateCurrentStreak(records),
      longestStreak: StreakCalculator.calculateLongestStreak(records),
      averageVariance: StreakCalculator.calculateAverageVariance(records),
      calendarData: calendar,
    );
  }
}

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsData>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return StatisticsNotifier(db);
});
