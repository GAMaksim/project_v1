import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:zzz/core/constants/notification_content.dart';
import 'package:zzz/core/utils/time_helpers.dart';
import 'package:zzz/data/models/sleep_schedule.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initialize the notification plugin.
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz_data.initializeTimeZones();

    // Skip platform-specific init on web
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      'zzz_bedtime',
      'Bedtime Reminders',
      description: 'Evening ritual reminders to help you sleep better',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  /// Handle notification tap actions
  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    if (response.actionId == 'went_to_bed') {
      debugPrint('User went to bed');
    } else if (response.actionId == 'delay_1h') {
      debugPrint('User delayed 1 hour');
    }
  }

  /// Schedule all 6 notifications for a specific day.
  Future<void> scheduleForDay(int dayOfWeek, String bedtime) async {
    if (kIsWeb) return;

    await cancelForDay(dayOfWeek);

    final contents = NotificationContents.all;

    for (int i = 0; i < contents.length; i++) {
      final content = contents[i];
      final notifTime =
          TimeHelpers.getNotificationTime(bedtime, content.offsetMinutes);

      if (notifTime.isAfter(DateTime.now())) {
        final notifId = dayOfWeek * 10 + i;

        AndroidNotificationDetails androidDetails;
        if (i == 5) {
          androidDetails = const AndroidNotificationDetails(
            'zzz_bedtime',
            'Bedtime Reminders',
            channelDescription: 'Evening ritual reminders',
            importance: Importance.high,
            priority: Priority.high,
            actions: [
              AndroidNotificationAction('went_to_bed', 'I went to bed 😴'),
              AndroidNotificationAction('delay_1h', 'Delay 1h'),
            ],
          );
        } else {
          androidDetails = const AndroidNotificationDetails(
            'zzz_bedtime',
            'Bedtime Reminders',
            channelDescription: 'Evening ritual reminders',
            importance: Importance.high,
            priority: Priority.high,
          );
        }

        final tzTime = tz.TZDateTime.from(notifTime, tz.local);

        await _plugin.zonedSchedule(
          notifId,
          content.title('en'),
          content.body('en'),
          tzTime,
          NotificationDetails(android: androidDetails),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: 'day_${dayOfWeek}_notif_$i',
        );
      }
    }
  }

  /// Schedule notifications for all enabled days.
  Future<void> scheduleAll(List<SleepSchedule> schedules) async {
    if (kIsWeb) return;

    await cancelAll();

    for (final schedule in schedules) {
      if (schedule.isEnabled) {
        await scheduleForDay(schedule.dayOfWeek, schedule.plannedBedtime);
      }
    }
  }

  /// Cancel all notifications for a specific day.
  Future<void> cancelForDay(int dayOfWeek) async {
    if (kIsWeb) return;

    for (int i = 0; i < 6; i++) {
      await _plugin.cancel(dayOfWeek * 10 + i);
    }
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }
}
