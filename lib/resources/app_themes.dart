import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/app_fonts.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData light2() {
    return ThemeData(
      primarySwatch: Colors.blue,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black.withOpacity(0),
      ),
    );
  }

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

      // scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      // bottomSheetTheme: const BottomSheetThemeData(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      // ),
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

        headlineLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F1F39),
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3D5CFF),
        ),

        headlineSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFFFF6905),
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
          wordSpacing: 1.0
          // color: AppColors.gray,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB8B8D2), // title under SignUp
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
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF858597),
          letterSpacing: 0.1,
          height: 1.5,

          // color: AppColors.gray,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFFFFFFF), // text in button1
          letterSpacing: 0.1,
          height: 1.5,

        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1F1F39),
        ),
      ),
      // scaffoldBackgroundColor: Colors.transparent,
      // scaffoldBackgroundColor: Colors.red,
      colorScheme: const ColorScheme.light().copyWith(
        // onSecondary: const Color(0xFFFFFFFF),          // free
        // onSecondaryContainer: const Color(0xFFFFFFFF), // free
        // tertiary: const Color(0xFFFFFFFF),
        // tertiaryContainer: const Color(0xFFFFFFFF),
        // onTertiaryContainer: const Color(0xFFFFFFFF), // free
        // error: const Color(0xFFFFFFFF),               // free
        // onError: const Color(0xFFFFFFFF),             // free
        // errorContainer: const Color(0xFFFFFFFF),      // free
        // onErrorContainer: const Color(0xFFFFFFFF),    // free
        // background: const Color(0xFFFFFFFF),
        // onBackground: const Color(0xFFFFFFFF),
        // surface: const Color(0xFFFFFFFF),
        // onSurface: const Color(0xFFFFFFFF),
        // surfaceVariant: const Color(0xFFFFFFFF),
        // onSurfaceVariant: const Color(0xFFFFFFFF),
        // outline: const Color(0xFFFFFFFF),
        // outlineVariant: const Color(0xFFFFFFFF),
        // shadow: const Color(0xFFFFFFFF),           // free
        // scrim: const Color(0xFFFFFFFF),
        // inverseSurface: const Color(0xFFFFFFFF),
        // onInverseSurface: const Color(0xFFFFFFFF),
        // inversePrimary: const Color(0xFFFFFFFF),
        // surfaceTint: const Color(0xFFFFFFFF),
        // primaryVariant: const Color(0xFFFFFFFF),   // deprecated
        // secondaryVariant: const Color(0xFFFFFFFF), // deprecated
        onSecondary: const Color(0xFFFFFFFF),
        background: const Color(0xFFFFFFFF),
        onBackground: const Color(0xFF1F1F39),
        primary: const Color(0xFF3D5CFF),
        onPrimary: const Color(0xFFFFFFFF),
        secondary: const Color(0xFF858597),
        secondaryContainer: const Color(0xFFEAEAFF),
        tertiary: const Color(0xFFF0F0F2),
        tertiaryContainer: const Color(0xFFFF5106),
        outline: const Color(0xFFB8B8D2),
        outlineVariant: const Color(0xFFB8B8D2),
        surface: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFFFFFFFF),
        scrim: const Color(0xFFF4F3FD),
        inverseSurface: const Color(0xFFF4F3FD),
        onInverseSurface: const Color(0xFFFFEBF0),
        surfaceVariant: const Color(0xFF3D5CFF),
        onSurfaceVariant: const Color(0xFFFFFFFF),
        surfaceTint: const Color(0xFFF4F3FD),
        inversePrimary: const Color(0xFFFFEBF0),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
        fontFamily: AppFonts.fontFamily,
        scaffoldBackgroundColor: const Color(0xFF1F1F39),
        colorScheme: const ColorScheme.dark().copyWith(
          onSecondary: const Color(0xFFFFFFFF).withOpacity(0.3),
          background: const Color(0xFF1F1F39),
          onBackground: const Color(0xFFEAEAFF),
          primary: const Color(0xFF3D5CFF),
          onPrimary: const Color(0xFF858597),
          // onPrimary: const Color(0xFFFF0000),
          secondary: const Color(0xFFEAEAFF),
          secondaryContainer: const Color(0xFFEAEAFF),
          tertiary: const Color(0xFF1F1F39),
          tertiaryContainer: const Color(0xFFFF5106),
          outline: const Color(0xFF3E3E55),
          outlineVariant: const Color(0xFFB8B8D2),
          surface: const Color(0xFF2F2F42),
          onSurface: const Color(0xFF3E3E55),
          scrim: const Color(0xFFB8B8D2),
          inverseSurface: const Color(0xFF3E3E55), // color in TextForm
          onInverseSurface: const Color(0xFF2F2F42),
          surfaceVariant: const Color(0xFFFFFFFF),
          onSurfaceVariant: const Color(0xFF3D5CFF),
          surfaceTint: const Color(0xFF858597),
          inversePrimary: const Color(0xFFFFEBF0),
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

          headlineLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFDADAF7),
          ),
          headlineMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3D5CFF),
          ),
          headlineSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFF6905),
          ),

          // title
          labelLarge: TextStyle(
            fontSize: 18,
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
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF4F3FD),
            letterSpacing: 0.1,
            height: 1.5,
            // color: AppColors.gray,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFFFF), // text in button1
            letterSpacing: 0.1,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1F1F39),
          ),
        ));
  }
}

// onSecondary: const Color(0xFFFFFFFF),
// secondaryContainer: const Color(0xFFFFFFFF),
// onSecondaryContainer: const Color(0xFFFFFFFF),
// tertiary: const Color(0xFFFFFFFF),
// onTertiary: const Color(0xFFFFFFFF),
// tertiaryContainer: const Color(0xFFFFFFFF),
// onTertiaryContainer: const Color(0xFFFFFFFF),
// error: const Color(0xFFFFFFFF),
// onError: const Color(0xFFFFFFFF),
// errorContainer: const Color(0xFFFFFFFF),
// onErrorContainer: const Color(0xFFFFFFFF),
// background: const Color(0xFFFFFFFF),
// onBackground: const Color(0xFFFFFFFF),
// surface: const Color(0xFFFFFFFF),
// onSurface: const Color(0xFFFFFFFF),
// surfaceVariant: const Color(0xFFFFFFFF),
// onSurfaceVariant: const Color(0xFFFFFFFF),
// outline: const Color(0xFFFFFFFF),
// outlineVariant: const Color(0xFFFFFFFF),
// shadow: const Color(0xFFFFFFFF),
// scrim: const Color(0xFFFFFFFF),
// inverseSurface: const Color(0xFFFFFFFF),
// onInverseSurface: const Color(0xFFFFFFFF),
// inversePrimary: const Color(0xFFFFFFFF),
// surfaceTint: const Color(0xFFFFFFFF),
// primaryVariant: const Color(0xFFFFFFFF),
// secondaryVariant: const Color(0xFFFFFFFF),
