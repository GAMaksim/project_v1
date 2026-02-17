import 'package:flutter/material.dart';
import 'package:zzz/core/theme/app_colors.dart';
import 'package:zzz/core/theme/app_text_styles.dart';

class SoundscapesScreen extends StatelessWidget {
  const SoundscapesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Text(
          'Soundscapes',
          style: AppTextStyles.displayMedium,
        ),
      ),
    );
  }
}
