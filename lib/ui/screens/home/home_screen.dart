import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/core/utils/time_helpers.dart';
import 'package:zzz/core/constants/notification_content.dart';
import 'package:zzz/providers/schedule_provider.dart';
import 'package:zzz/ui/widgets/timer_circle.dart';
import 'package:zzz/ui/widgets/notification_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedules = ref.watch(scheduleProvider);
    final todayIndex = TimeHelpers.getCurrentDayOfWeek();

    final todaySchedule = schedules.firstWhere(
      (s) => s.dayOfWeek == todayIndex && s.isEnabled,
      orElse: () => schedules.firstWhere(
        (s) => s.isEnabled,
        orElse: () => schedules.first,
      ),
    );

    final bedtime = todaySchedule.plannedBedtime;
    final timeRemaining = TimeHelpers.getTimeUntilBedtime(bedtime);
    final progress = TimeHelpers.getProgressTowardBedtime(bedtime);

    // Build notification list
    final now = DateTime.now();
    final notifications = NotificationContents.all.map((n) {
      final notifTime = TimeHelpers.getNotificationTime(bedtime, n.offsetMinutes);
      return _NotifItem(
        time: TimeHelpers.formatTime(notifTime),
        title: n.title('en'),
        body: n.body('en'),
        dateTime: notifTime,
        isPast: notifTime.isBefore(now),
      );
    }).toList();

    // Find the next upcoming notification
    final nextIndex = notifications.indexWhere((n) => !n.isPast);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header: "Today" + date
              Text(
                'Today',
                style: AppTextStyles.displaySmall,
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 4),

              Text(
                TimeHelpers.getFormattedDate(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 32),

              // Timer Circle
              Center(
                child: TimerCircle(
                  timeRemaining: timeRemaining,
                  progress: progress,
                  bedtime: bedtime,
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),
              ),

              const SizedBox(height: 40),

              // Evening Ritual section
              Text(
                'Evening Ritual',
                style: AppTextStyles.headlineMedium,
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms),

              const SizedBox(height: 4),

              Text(
                'Your personalized wind-down sequence',
                style: AppTextStyles.bodySmall,
              ).animate().fadeIn(duration: 500.ms, delay: 500.ms),

              const SizedBox(height: 16),

              // Notification cards
              ...List.generate(notifications.length, (i) {
                final notif = notifications[i];
                return NotificationCard(
                  time: notif.time,
                  title: notif.title,
                  body: notif.body,
                  isNext: i == nextIndex,
                  isPast: notif.isPast,
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifItem {
  final String time;
  final String title;
  final String body;
  final DateTime dateTime;
  final bool isPast;

  _NotifItem({
    required this.time,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.isPast,
  });
}
