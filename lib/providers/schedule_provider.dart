import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sleep_schedule.dart';
import '../data/services/database_service.dart';
import 'settings_provider.dart';

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, List<SleepSchedule>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return ScheduleNotifier(db);
});

class ScheduleNotifier extends StateNotifier<List<SleepSchedule>> {
  final DatabaseService _db;

  ScheduleNotifier(this._db) : super(_db.allSchedules);

  void reload() {
    state = _db.allSchedules;
  }

  Future<void> updateScheduleForDay(
    int dayOfWeek, {
    String? bedtime,
    bool? isEnabled,
  }) async {
    final schedule = _db.getScheduleForDay(dayOfWeek);
    if (schedule != null) {
      if (bedtime != null) schedule.plannedBedtime = bedtime;
      if (isEnabled != null) schedule.isEnabled = isEnabled;
      await _db.updateSchedule(schedule);
      state = _db.allSchedules;
    }
  }

  Future<void> updateAllSchedules(List<SleepSchedule> schedules) async {
    await _db.updateAllSchedules(schedules);
    state = _db.allSchedules;
  }

  SleepSchedule? getTodaySchedule() {
    final today = DateTime.now().weekday % 7; // Convert to 0=Sun format
    return state.firstWhere(
      (s) => s.dayOfWeek == today,
      orElse: () => SleepSchedule(dayOfWeek: today),
    );
  }
}
