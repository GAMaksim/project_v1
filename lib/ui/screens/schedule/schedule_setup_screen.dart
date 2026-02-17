import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ScheduleSetupScreen extends StatelessWidget {
  const ScheduleSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Text(
          'Schedule Setup',
          style: AppTextStyles.displayMedium,
        ),
      ),
    );
  }
}
