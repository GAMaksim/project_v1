import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_settings.dart';
import '../models/sleep_schedule.dart';
import '../models/sleep_record.dart';

class DatabaseService {
  static const String _settingsBox = 'settings';
  static const String _scheduleBox = 'schedule';
  static const String _recordsBox = 'records';

  late Box<UserSettings> _settingsBoxInstance;
  late Box<SleepSchedule> _scheduleBoxInstance;
  late Box<SleepRecord> _recordsBoxInstance;

  // === Initialization ===

  Future<void> initHive() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserSettingsAdapter());
    Hive.registerAdapter(SleepScheduleAdapter());
    Hive.registerAdapter(SleepRecordAdapter());

    // Open boxes
    _settingsBoxInstance = await Hive.openBox<UserSettings>(_settingsBox);
    _scheduleBoxInstance = await Hive.openBox<SleepSchedule>(_scheduleBox);
    _recordsBoxInstance = await Hive.openBox<SleepRecord>(_recordsBox);

    // Create default data on first launch
    await _initializeDefaults();
  }

  Future<void> _initializeDefaults() async {
    // Create default UserSettings if not exists
    if (_settingsBoxInstance.isEmpty) {
      await _settingsBoxInstance.put('main', UserSettings());
    }

    // Create 7 SleepSchedule entries (one per day) if not exists
    if (_scheduleBoxInstance.isEmpty) {
      for (int i = 0; i < 7; i++) {
        await _scheduleBoxInstance.put(
          i,
          SleepSchedule(dayOfWeek: i),
        );
      }
    }
  }

  // === UserSettings CRUD ===

  UserSettings get settings =>
      _settingsBoxInstance.get('main') ?? UserSettings();

  Future<void> updateSettings(UserSettings settings) async {
    await _settingsBoxInstance.put('main', settings);
  }

  // === SleepSchedule CRUD ===

  List<SleepSchedule> get allSchedules =>
      _scheduleBoxInstance.values.toList();

  SleepSchedule? getScheduleForDay(int dayOfWeek) =>
      _scheduleBoxInstance.get(dayOfWeek);

  Future<void> updateSchedule(SleepSchedule schedule) async {
    await _scheduleBoxInstance.put(schedule.dayOfWeek, schedule);
  }

  Future<void> updateAllSchedules(List<SleepSchedule> schedules) async {
    for (final schedule in schedules) {
      await _scheduleBoxInstance.put(schedule.dayOfWeek, schedule);
    }
  }

  // === SleepRecord CRUD ===

  List<SleepRecord> get allRecords =>
      _recordsBoxInstance.values.toList();

  List<SleepRecord> getRecordsForPeriod(DateTime start, DateTime end) {
    return _recordsBoxInstance.values.where((record) {
      return record.date.isAfter(start.subtract(const Duration(days: 1))) &&
          record.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  List<SleepRecord> getRecentRecords(int days) {
    final start = DateTime.now().subtract(Duration(days: days));
    return getRecordsForPeriod(start, DateTime.now());
  }

  Future<void> addRecord(SleepRecord record) async {
    await _recordsBoxInstance.add(record);
  }

  Future<void> updateRecord(SleepRecord record) async {
    await record.save();
  }

  Future<void> deleteRecord(SleepRecord record) async {
    await record.delete();
  }
}
