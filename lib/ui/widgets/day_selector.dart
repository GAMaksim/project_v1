import 'package:flutter/material.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';
import 'package:zzz/core/utils/sleep_score.dart';
import 'package:zzz/ui/widgets/sleep_score_badge.dart';

class DaySelector extends StatelessWidget {
  final String dayName;
  final String bedtime;
  final bool isEnabled;
  final ValueChanged<String> onBedtimeChanged;
  final ValueChanged<bool> onEnabledChanged;

  const DaySelector({
    super.key,
    required this.dayName,
    required this.bedtime,
    required this.isEnabled,
    required this.onBedtimeChanged,
    required this.onEnabledChanged,
  });

  Future<void> _pickTime(BuildContext context) async {
    final parts = bedtime.split(':');
    final initial = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepIndigo,
              onPrimary: Colors.white,
              surface: AppColors.cream,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';
      onBedtimeChanged(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoreResult = SleepScore.calculate(bedtime);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isEnabled ? 1.0 : 0.4,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled
                ? AppColors.whisperGray
                : AppColors.whisperGray.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Toggle
            GestureDetector(
              onTap: () => onEnabledChanged(!isEnabled),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isEnabled ? AppColors.deepIndigo : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isEnabled ? AppColors.deepIndigo : AppColors.whisperGray,
                    width: 2,
                  ),
                ),
                child: isEnabled
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),
            const SizedBox(width: 16),

            // Day name
            Expanded(
              child: Text(
                dayName,
                style: AppTextStyles.headlineSmall,
              ),
            ),

            // Time + Score
            if (isEnabled)
              GestureDetector(
                onTap: () => _pickTime(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      bedtime,
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColors.deepIndigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SleepScoreBadge(result: scoreResult),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
