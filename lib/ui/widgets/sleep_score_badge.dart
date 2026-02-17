import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/core/utils/sleep_score.dart';

class SleepScoreBadge extends StatelessWidget {
  final SleepScoreResult result;

  const SleepScoreBadge({super.key, required this.result});

  Color get _color {
    switch (result.rating) {
      case SleepRating.excellent:
        return AppColors.success;
      case SleepRating.good:
        return AppColors.softMauve;
      case SleepRating.fair:
        return AppColors.warning;
      case SleepRating.poor:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${result.score}',
            style: AppTextStyles.headlineLarge.copyWith(
              color: _color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '✦',
            style: TextStyle(color: _color, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            result.ratingLabel,
            style: AppTextStyles.labelLarge.copyWith(color: _color),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}
