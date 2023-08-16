import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/app_fonts.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData light() {
    return ThemeData(
      fontFamily: AppFonts.fontFamily,
      useMaterial3: true,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF1F1F39),
        selectionColor: Color(0xFF858597),
        selectionHandleColor: Color(0xFF858597),
      ),
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
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1F1F39),
        ),

        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3D5CFF),
        ),

        // title
        titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF858597),
          // color: AppColors.gray,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF858597),
          // color: AppColors.gray,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB8B8D2),  // title under SignUp
          // color: AppColors.gray,
        ),

        // label
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F1F39), // text in button1
        ),
        labelMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF), // text in button1
        ),

        labelSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF3D5CFF), // text in button2
        ),

        // body
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFFFFFFF), // text in button1
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1F1F39),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      colorScheme: const ColorScheme.light().copyWith(
        background: const Color(0xFFFFFFFF),
        onBackground: const Color(0xFF1F1F39),
        primary: const Color(0xFF3D5CFF), // buttotn1
        onPrimary: const Color(0xFFFFFFFF), // buttotn2
        secondary: const Color(0xFF858597),
        tertiary: const Color(0xFFF0F0F2),
        outline: const Color(0xFFB8B8D2), // 4 outlineBorder
        outlineVariant: const Color(0xFFB8B8D2), // 4 outlineBorder
        surface: const Color(0xFFFFFFFF), // substrate in SignUpPage...
        surfaceVariant: const Color(0xFFFFFFFF), // color in TextForm
        scrim: const Color(0xFFF4F3FD), // color in TextForm
        inverseSurface: const Color(0xFFF4F3FD), // color in TextForm
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      fontFamily: AppFonts.fontFamily,
      scaffoldBackgroundColor: const Color(0xFF1F1F39),
      colorScheme: const ColorScheme.dark().copyWith(
        background: const Color(0xFF1F1F39),
        onBackground: const Color(0xFFEAEAFF),
        primary: const Color(0xFF3D5CFF), // button1
        onPrimary: const Color(0xFF858597), // button2
        secondary: const Color(0xFFEAEAFF),
        tertiary: const Color(0xFF1F1F39),
        outline: const Color(0xFF3E3E55), // 4 outlineBorder
        outlineVariant: const Color(0xFFB8B8D2), // 4 outlineBorder
        surface: const Color(0xFF2F2F42), // substrate in SignUpPage...
        surfaceVariant: const Color(0xFF3E3E55), // color in TextForm
        scrim: const Color(0xFFB8B8D2), // color in TextForm
        inverseSurface: const Color(0xFF3E3E55), // color in TextForm
      ),
      useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFFFFFFF),
          selectionColor: Color(0xFFB8B8D2),
          selectionHandleColor: Color(0xFFB8B8D2),
        ),
        textTheme: const TextTheme(
          // display
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
          displayMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFFEAEAFF),
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF4F3FD),
          ),

          headlineMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3D5CFF),
          ),

          // title
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF), // text in button1
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF4F3FD),
            // color: AppColors.gray,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB8B8D2), // title under SignUp
            // color: AppColors.gray,
          ),

          // label
          titleLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB8B8D2),
            // color: AppColors.gray,
          ),
          labelMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFF4F3FD), // text in button1
          ),
          labelSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFF4F3FD), // text in button2
          ),

          // body
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFFFF), // text in button1
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1F1F39),
          ),
        )
    );
  }
}
