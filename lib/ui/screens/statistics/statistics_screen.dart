import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/providers/statistics_provider.dart';
import 'package:zzz/providers/settings_provider.dart';
import 'package:zzz/ui/widgets/stat_card.dart';
import 'package:zzz/ui/widgets/calendar_grid.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);
    final settings = ref.watch(settingsProvider);
    final isPremium = settings.isPremium;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header
              Text(
                'Progress',
                style: AppTextStyles.displaySmall,
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 4),

              Text(
                'Your sleep journey insights',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 24),

              // Card 1: Restful Nights
              StatCard(
                title: 'Restful Nights',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${stats.onTimeNights}',
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.deepIndigo,
                          ),
                        ),
                        Text(
                          ' / ${stats.totalNights}',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(stats.successRate * 100).toInt()}%',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: _rateColor(stats.successRate),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: stats.successRate,
                        minHeight: 8,
                        backgroundColor: AppColors.whisperGray,
                        color: _rateColor(stats.successRate),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _rateMessage(stats.successRate),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              // Card 2: Streaks
              StatCard(
                title: 'Streaks',
                child: Row(
                  children: [
                    Expanded(
                      child: _StreakBadge(
                        label: 'Current',
                        value: stats.currentStreak,
                        icon: '🔥',
                        color: AppColors.deepIndigo,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StreakBadge(
                        label: 'Best',
                        value: stats.longestStreak,
                        icon: '🏆',
                        color: AppColors.warmSand,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

              // Card 3: Average Timing
              StatCard(
                title: 'Average Timing',
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.softMauve.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('⏱️', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '±${stats.averageVariance} min',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: stats.averageVariance <= 15
                                ? AppColors.success
                                : stats.averageVariance <= 30
                                    ? AppColors.warmSand
                                    : AppColors.error,
                          ),
                        ),
                        Text(
                          'Average deviation from planned',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

              // Card 4: Calendar (premium gate for older data)
              StatCard(
                title: 'Monthly Overview',
                isLocked: !isPremium && stats.totalNights > 7,
                child: CalendarGrid(data: stats.calendarData),
              ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

              // Card 5: Achievements
              StatCard(
                title: 'Achievements',
                child: Column(
                  children: [
                    _AchievementRow(
                      icon: '🌟',
                      title: 'First Night',
                      description: 'Track your first bedtime',
                      unlocked: stats.totalNights >= 1,
                    ),
                    const Divider(height: 24),
                    _AchievementRow(
                      icon: '🔥',
                      title: '7-Day Streak',
                      description: '7 consecutive on-time nights',
                      unlocked: stats.longestStreak >= 7,
                    ),
                    const Divider(height: 24),
                    _AchievementRow(
                      icon: '👑',
                      title: 'Sleep Master',
                      description: '30 days with 80%+ success rate',
                      unlocked: stats.totalNights >= 30 &&
                          stats.successRate >= 0.8,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 600.ms),

              // Empty state
              if (stats.totalNights == 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.deepIndigo.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.deepIndigo.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('🌙', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        'No sleep data yet',
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your progress will appear here after your first tracked night.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 300.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Color _rateColor(double rate) {
    if (rate >= 0.8) return AppColors.success;
    if (rate >= 0.5) return AppColors.warmSand;
    return AppColors.error;
  }

  String _rateMessage(double rate) {
    if (rate >= 0.8) return 'Excellent consistency! Keep it up 🌟';
    if (rate >= 0.5) return 'Good progress. Try to be more consistent.';
    return 'Room for improvement. Set realistic bedtimes.';
  }
}

class _StreakBadge extends StatelessWidget {
  final String label;
  final int value;
  final String icon;
  final Color color;

  const _StreakBadge({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: AppTextStyles.displaySmall.copyWith(color: color),
          ),
          Text(
            '$label days',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final bool unlocked;

  const _AchievementRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.4,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle, color: AppColors.success, size: 24)
          else
            Icon(Icons.lock_outline,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                size: 20),
        ],
      ),
    );
  }
}
