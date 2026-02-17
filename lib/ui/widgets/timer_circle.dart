import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';

class TimerCircle extends StatelessWidget {
  final String timeRemaining; // "2:19"
  final double progress; // 0.0 to 1.0
  final String bedtime; // "22:00"

  const TimerCircle({
    super.key,
    required this.timeRemaining,
    required this.progress,
    required this.bedtime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress
          CustomPaint(
            size: const Size(280, 280),
            painter: _TimerCirclePainter(progress: progress),
          ),

          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Until rest',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                timeRemaining,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 72,
                  color: AppColors.deepIndigo,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bedtime $bedtime',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softMauve,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerCirclePainter extends CustomPainter {
  final double progress;

  _TimerCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Background track
    final trackPaint = Paint()
      ..color = AppColors.whisperGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc with gradient
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      final gradientPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [
            AppColors.softMauve,
            AppColors.warmSand,
            AppColors.deepIndigo,
          ],
          stops: [0.0, 0.5, 1.0],
        ).createShader(rect);

      // Draw arc from top (-π/2) going clockwise
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        gradientPaint,
      );

      // End dot
      final dotAngle = -math.pi / 2 + 2 * math.pi * progress;
      final dotX = center.dx + radius * math.cos(dotAngle);
      final dotY = center.dy + radius * math.sin(dotAngle);

      final dotPaint = Paint()
        ..color = AppColors.deepIndigo
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 8, dotPaint);

      // Inner glow on dot
      final glowPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 4, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_TimerCirclePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
