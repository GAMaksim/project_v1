import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/core/utils/sleep_score.dart';
import 'package:zzz/data/models/sleep_schedule.dart';
import 'package:zzz/providers/schedule_provider.dart';
import 'package:zzz/data/services/notification_service.dart';
import 'package:zzz/ui/widgets/day_selector.dart';
import 'package:zzz/ui/widgets/recommendation_card.dart';
import 'package:zzz/ui/shared/primary_button.dart';

class ScheduleSetupScreen extends ConsumerStatefulWidget {
  const ScheduleSetupScreen({super.key});

  @override
  ConsumerState<ScheduleSetupScreen> createState() =>
      _ScheduleSetupScreenState();
}

class _ScheduleSetupScreenState extends ConsumerState<ScheduleSetupScreen> {
  static const _dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Local state for editing before save
  late List<_DayState> _days;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final schedules = ref.read(scheduleProvider);
    _days = List.generate(7, (i) {
      final schedule = schedules.firstWhere(
        (s) => s.dayOfWeek == i,
        orElse: () => SleepSchedule(dayOfWeek: i),
      );
      return _DayState(
        bedtime: schedule.plannedBedtime,
        isEnabled: schedule.isEnabled,
      );
    });
  }

  int get _enabledCount => _days.where((d) => d.isEnabled).length;

  String? get _mostCommonBedtime {
    final enabled = _days.where((d) => d.isEnabled).toList();
    if (enabled.isEmpty) return null;
    // Return the bedtime of the first enabled day for the recommendation card
    return enabled.first.bedtime;
  }

  Future<void> _save() async {
    if (_enabledCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enable at least one day',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.deepIndigo,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final schedules = List.generate(
      7,
      (i) => SleepSchedule(dayOfWeek: i)
        ..plannedBedtime = _days[i].bedtime
        ..isEnabled = _days[i].isEnabled,
    );

    await ref.read(scheduleProvider.notifier).updateAllSchedules(schedules);

    // Schedule push notifications
    await NotificationService().scheduleAll(schedules);

    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoreResult = _mostCommonBedtime != null
        ? SleepScore.calculate(_mostCommonBedtime!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Sleep Schedule',
                    style: AppTextStyles.displaySmall,
                  ).animate().fadeIn(duration: 500.ms).slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 8),
                  Text(
                    'Set your ideal bedtime for each day',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Day list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  ...List.generate(7, (i) {
                    return DaySelector(
                      dayName: _dayNames[i],
                      bedtime: _days[i].bedtime,
                      isEnabled: _days[i].isEnabled,
                      onBedtimeChanged: (time) {
                        setState(() => _days[i].bedtime = time);
                      },
                      onEnabledChanged: (enabled) {
                        setState(() => _days[i].isEnabled = enabled);
                      },
                    );
                  }),

                  // Recommendation card
                  if (scoreResult != null) ...[
                    const SizedBox(height: 8),
                    RecommendationCard(result: scoreResult),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                text: 'Save Schedule',
                onPressed: _save,
                isLoading: _isSaving,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayState {
  String bedtime;
  bool isEnabled;

  _DayState({
    this.bedtime = '22:30',
    this.isEnabled = true,
  });
}
