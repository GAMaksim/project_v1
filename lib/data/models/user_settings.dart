import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 0)
class UserSettings extends HiveObject {
  @HiveField(0)
  late bool isPremium;

  @HiveField(1)
  late bool onboardingCompleted;

  @HiveField(2)
  late String language; // 'en' | 'ru'

  @HiveField(3)
  String? selectedSoundId;

  @HiveField(4)
  late bool notificationsEnabled;

  UserSettings({
    this.isPremium = false,
    this.onboardingCompleted = false,
    this.language = 'en',
    this.selectedSoundId,
    this.notificationsEnabled = true,
  });
}
