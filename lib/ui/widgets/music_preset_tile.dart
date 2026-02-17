import 'package:flutter/material.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/core/constants/sounds.dart';

class MusicPresetTile extends StatelessWidget {
  final SoundPreset preset;
  final bool isPlaying;
  final bool isLocked; // premium & user not premium
  final VoidCallback onTap;

  const MusicPresetTile({
    super.key,
    required this.preset,
    required this.isPlaying,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.deepIndigo.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPlaying
                ? AppColors.deepIndigo.withValues(alpha: 0.4)
                : AppColors.whisperGray,
            width: isPlaying ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isPlaying
                    ? AppColors.deepIndigo.withValues(alpha: 0.12)
                    : AppColors.cream,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  preset.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Name + Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        preset.name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: isPlaying
                              ? AppColors.deepIndigo
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 6),
                        const Text('🔒', style: TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preset.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Play/Pause indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isPlaying
                  ? Icon(
                      Icons.pause_circle_filled,
                      key: const ValueKey('pause'),
                      color: AppColors.deepIndigo,
                      size: 36,
                    )
                  : Icon(
                      Icons.play_circle_outline,
                      key: const ValueKey('play'),
                      color: isLocked
                          ? AppColors.textSecondary
                          : AppColors.softMauve,
                      size: 36,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
