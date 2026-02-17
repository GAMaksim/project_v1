/// Time utility functions for bedtime calculations.
/// All bedtime strings are in "HH:mm" format (24h).

class TimeHelpers {
  TimeHelpers._();

  /// Parse "HH:mm" to DateTime today (or tomorrow if time already passed).
  static DateTime parseBedtimeToday(String bedtime) {
    final parts = bedtime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();

    var target = DateTime(now.year, now.month, now.day, hour, minute);

    // If bedtime is before current hour and likely means "tonight"
    // e.g. bedtime "01:00" at 14:00 → means tonight (tomorrow 01:00)
    // e.g. bedtime "22:00" at 14:00 → means tonight (today 22:00)
    // e.g. bedtime "22:00" at 23:00 → already passed → tomorrow
    if (target.isBefore(now)) {
      // If it's an early morning time (0-5am), it likely means tonight
      if (hour < 6) {
        target = target.add(const Duration(days: 1));
      }
      // If it's an evening time that already passed, it means tomorrow
      else {
        target = target.add(const Duration(days: 1));
      }
    }

    return target;
  }

  /// Get formatted time remaining until bedtime, e.g. "2:19" or "0:45"
  static String getTimeUntilBedtime(String bedtime) {
    final target = parseBedtimeToday(bedtime);
    final now = DateTime.now();
    final diff = target.difference(now);

    if (diff.isNegative) return '0:00';

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  /// Get progress toward bedtime as 0.0 to 1.0.
  /// Assumes the "active period" starts at wake-up (8:00 by default).
  static double getProgressTowardBedtime(String bedtime) {
    final target = parseBedtimeToday(bedtime);
    final now = DateTime.now();

    // Assume wake time is ~14 hours before bedtime
    final wakeTime = target.subtract(const Duration(hours: 14));

    final totalDuration = target.difference(wakeTime).inMinutes;
    final elapsed = now.difference(wakeTime).inMinutes;

    if (elapsed <= 0) return 0.0;
    if (elapsed >= totalDuration) return 1.0;

    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  /// Get the notification DateTime for a specific offset from bedtime.
  /// Offset is in minutes (negative = before, positive = after bedtime).
  static DateTime getNotificationTime(String bedtime, int offsetMinutes) {
    final target = parseBedtimeToday(bedtime);
    return target.add(Duration(minutes: offsetMinutes));
  }

  /// Format DateTime to "HH:mm"
  static String formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Get readable date string, e.g. "Monday, Feb 17"
  static String getFormattedDate() {
    final now = DateTime.now();
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  /// Get current day of week in 0=Sun format (matching SleepSchedule)
  static int getCurrentDayOfWeek() {
    return DateTime.now().weekday % 7; // DateTime: 1=Mon..7=Sun → 0=Sun
  }
}
