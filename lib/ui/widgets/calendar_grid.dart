import 'package:flutter/material.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';

class CalendarGrid extends StatelessWidget {
  final Map<DateTime, bool> data; // date → onTime

  const CalendarGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    // Monday = 1, Sunday = 7 → offset for grid
    final startWeekday = firstDay.weekday; // 1=Mon

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month header
        Text(
          _monthName(now.month),
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
              .map((d) => SizedBox(
                    width: 36,
                    child: Text(
                      d,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar cells
        ...List.generate(6, (week) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (weekday) {
                final dayIndex = week * 7 + weekday - (startWeekday - 1);

                if (dayIndex < 0 || dayIndex >= daysInMonth) {
                  return const SizedBox(width: 36, height: 36);
                }

                final day = dayIndex + 1;
                final date = DateTime(now.year, now.month, day);
                final isToday = day == now.day;
                final hasData = data.containsKey(date);
                final onTime = data[date] ?? false;

                return Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: hasData
                        ? (onTime
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.error.withValues(alpha: 0.15))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(color: AppColors.deepIndigo, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isToday
                            ? AppColors.deepIndigo
                            : AppColors.textPrimary,
                        fontWeight:
                            isToday ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }
}
