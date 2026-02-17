import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // === Headings (Cormorant Garamond — elegant serif) ===

  static TextStyle displayLarge = GoogleFonts.cormorantGaramond(
    fontSize: 72,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.cormorantGaramond(
    fontSize: 42,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.cormorantGaramond(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineLarge = GoogleFonts.cormorantGaramond(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.cormorantGaramond(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.cormorantGaramond(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // === Body (Inter — modern sans) ===

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // === Labels ===

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // === Button ===

  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
