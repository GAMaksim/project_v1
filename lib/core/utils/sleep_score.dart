/// Sleep Score calculation based on planned bedtime.
///
/// Scoring:
/// 21:00–22:30 → 90+ "Excellent"
/// 22:30–23:00 → ~78 "Good"
/// 23:00–00:00 → ~65 "Fair"
/// after 00:00 → ~40 "Poor"

enum SleepRating { excellent, good, fair, poor }

class SleepScoreResult {
  final int score;
  final SleepRating rating;
  final String ratingLabel;
  final String recommendation;
  final List<String> benefits;
  final List<String> risks;

  const SleepScoreResult({
    required this.score,
    required this.rating,
    required this.ratingLabel,
    required this.recommendation,
    required this.benefits,
    required this.risks,
  });
}

class SleepScore {
  SleepScore._();

  /// Calculate sleep score from bedtime string like "22:00"
  static SleepScoreResult calculate(String bedtime) {
    final parts = bedtime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final totalMinutes = hour * 60 + minute;

    // Normalize: treat times 0:00-5:00 as "after midnight" (24:00-29:00)
    final normalized = totalMinutes < 360 ? totalMinutes + 1440 : totalMinutes;

    // 21:00 = 1260, 22:30 = 1350, 23:00 = 1380, 00:00 = 1440
    if (normalized >= 1260 && normalized <= 1350) {
      // 21:00 – 22:30 → Excellent
      final score = 95 - ((normalized - 1260) * 5 ~/ 90);
      return SleepScoreResult(
        score: score.clamp(90, 98),
        rating: SleepRating.excellent,
        ratingLabel: 'Excellent',
        recommendation: 'Perfect timing! Your body will thank you.',
        benefits: [
          'Optimal melatonin production',
          'Deep sleep cycles maximized',
          'Morning energy boost',
        ],
        risks: [],
      );
    } else if (normalized > 1350 && normalized <= 1380) {
      // 22:30 – 23:00 → Good
      final score = 82 - ((normalized - 1350) * 7 ~/ 30);
      return SleepScoreResult(
        score: score.clamp(75, 82),
        rating: SleepRating.good,
        ratingLabel: 'Good',
        recommendation: 'Solid choice. Consider 30 minutes earlier for best results.',
        benefits: [
          'Adequate rest periods',
          'Reasonable recovery time',
        ],
        risks: [
          'Slightly delayed melatonin peak',
        ],
      );
    } else if (normalized > 1380 && normalized <= 1440) {
      // 23:00 – 00:00 → Fair
      final score = 70 - ((normalized - 1380) * 10 ~/ 60);
      return SleepScoreResult(
        score: score.clamp(60, 70),
        rating: SleepRating.fair,
        ratingLabel: 'Fair',
        recommendation: 'Your body prefers earlier rest. Try 22:30.',
        benefits: [
          'Still getting some deep sleep',
        ],
        risks: [
          'Reduced deep sleep phases',
          'Higher morning cortisol',
        ],
      );
    } else {
      // After 00:00 → Poor
      final minutesAfterMidnight = normalized - 1440;
      final score = 50 - (minutesAfterMidnight * 20 ~/ 120);
      return SleepScoreResult(
        score: score.clamp(20, 50),
        rating: SleepRating.poor,
        ratingLabel: 'Poor',
        recommendation: '⚠️ Elevated cortisol levels. We recommend: 22:30',
        benefits: [],
        risks: [
          'Significantly elevated cortisol',
          'Disrupted circadian rhythm',
          'Compromised immune function',
          'Increased stress hormones',
        ],
      );
    }
  }
}
