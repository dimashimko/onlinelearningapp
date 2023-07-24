import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:flutter/material.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData light() {
    return ThemeData(
      fontFamily: AppFonts.fontFamily,
      scaffoldBackgroundColor: AppColors.scaffold,
      colorScheme: const ColorScheme.light().copyWith(
        background: AppColors.white,
        onBackground: const Color(0xFF1F1F39),
        primary: const Color(0xFF3D5CFF),
        secondary: const Color(0xFF858597),

      ),
      useMaterial3: true,
      // display LMS(3), title LMS(3), label LMS(3), body LMS+T1T2(5)
      // button → label
      textTheme: const TextTheme(
        // display
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F1F39),
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F1F39),
        ),

        // title
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF858597),
          // color: AppColors.gray,
        ),

        // label
        labelMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),

        // body
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1F1F39),
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      fontFamily: AppFonts.fontFamily,
      scaffoldBackgroundColor: AppColors.scaffold,
      colorScheme: const ColorScheme.dark().copyWith(
        background: AppColors.white,
        onBackground: const Color(0xFFEAEAFF),
        primary: const Color(0xFF3D5CFF),
        secondary: const Color(0xFFEAEAFF),
      ),
      useMaterial3: true,
    );
  }
}
