import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/core/utils/sleep_score.dart';

class RecommendationCard extends StatelessWidget {
  final SleepScoreResult result;

  const RecommendationCard({super.key, required this.result});

  Color get _accentColor {
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
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.whisperGray),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left color bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.recommendation,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (result.benefits.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...result.benefits.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Text('→ ',
                                  style: TextStyle(
                                      color: AppColors.success, fontSize: 14)),
                              Expanded(
                                child: Text(b, style: AppTextStyles.bodySmall),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (result.risks.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...result.risks.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Text('→ ',
                                  style: TextStyle(
                                      color: AppColors.warning, fontSize: 14)),
                              Expanded(
                                child: Text(r, style: AppTextStyles.bodySmall),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOut,
        );
  }
}
