import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';

class NotificationCard extends StatelessWidget {
  final String time;
  final String title;
  final String body;
  final bool isNext; // true = first upcoming, brighter
  final bool isPast; // true = already happened

  const NotificationCard({
    super.key,
    required this.time,
    required this.title,
    required this.body,
    this.isNext = false,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = isPast ? 0.4 : (isNext ? 1.0 : 0.6);
    final accentColor = isNext ? AppColors.deepIndigo : AppColors.warmSand;

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isNext
                ? AppColors.deepIndigo.withValues(alpha: 0.3)
                : AppColors.whisperGray,
          ),
          boxShadow: isNext
              ? [
                  BoxShadow(
                    color: AppColors.deepIndigo.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time
                      SizedBox(
                        width: 50,
                        child: Text(
                          time,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isNext
                                ? AppColors.deepIndigo
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title + Body
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: isNext
                                    ? AppColors.deepIndigo
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              body,
                              style: AppTextStyles.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Status icon
                      if (isPast)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        )
                      else if (isNext)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.deepIndigo,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(
          begin: 0.05,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}
