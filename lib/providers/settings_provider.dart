import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_settings.dart';
import '../data/services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return SettingsNotifier(db);
});

class SettingsNotifier extends StateNotifier<UserSettings> {
  final DatabaseService _db;

  SettingsNotifier(this._db) : super(_db.settings);

  Future<void> setLanguage(String language) async {
    state.language = language;
    await _db.updateSettings(state);
    state = _db.settings;
  }

  Future<void> setPremium(bool isPremium) async {
    state.isPremium = isPremium;
    await _db.updateSettings(state);
    state = _db.settings;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    state.onboardingCompleted = completed;
    await _db.updateSettings(state);
    state = _db.settings;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state.notificationsEnabled = enabled;
    await _db.updateSettings(state);
    state = _db.settings;
  }

  Future<void> setSelectedSound(String? soundId) async {
    state.selectedSoundId = soundId;
    await _db.updateSettings(state);
    state = _db.settings;
  }
}
