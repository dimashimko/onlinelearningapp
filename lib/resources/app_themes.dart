import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = AppThemes.light();

  ThemeData get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDark') ?? false;

    _currentTheme = isDark ? AppThemes.dark() : AppThemes.light();
    notifyListeners();
  }

  void toggleTheme() async {
    _currentTheme = _currentTheme == AppThemes.light()
        ? AppThemes.dark()
        : AppThemes.light();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _currentTheme == AppThemes.dark());

    notifyListeners();
  }
}

AppColors colors(context) => Theme.of(context).extension<AppColors>()!;

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color? redLight;
  final Color? red;
  final Color? blueLight;
  final Color? blue;
  final Color? greenLight;
  final Color? green;
  final Color? white;
  final Color? orange;
  final Color? violetLight;
  final Color? grey;
  final Color? greyDark;
  final Color? pink;
  final Color? violet;

  const AppColors({
    required this.redLight,
    required this.red,
    required this.blueLight,
    required this.blue,
    required this.greenLight,
    required this.green,
    required this.white,
    required this.orange,
    required this.violetLight,
    required this.grey,
    required this.greyDark,
    required this.pink,
    required this.violet,
  });

  @override
  AppColors copyWith({
    Color? redLight,
    Color? red,
    Color? blueLight,
    Color? blue,
    Color? greenLight,
    Color? green,
    Color? white,
    Color? orange,
    Color? violetLight,
    Color? grey,
    Color? greyDark,
    Color? pink,
    Color? violet,
  }) {
    return AppColors(
      redLight: redLight ?? this.redLight,
      red: red ?? this.red,
      blueLight: blueLight ?? this.blueLight,
      blue: blue ?? this.blue,
      greenLight: greenLight ?? this.greenLight,
      green: green ?? this.green,
      white: white ?? this.white,
      orange: orange ?? this.orange,
      violetLight: violetLight ?? this.violetLight,
      grey: grey ?? this.grey,
      greyDark: greyDark ?? this.greyDark,
      pink: pink ?? this.pink,
      violet: violet ?? this.violet,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      redLight: Color.lerp(redLight, other.redLight, t),
      red: Color.lerp(red, other.red, t),
      blueLight: Color.lerp(blueLight, other.blueLight, t),
      blue: Color.lerp(blue, other.blue, t),
      greenLight: Color.lerp(greenLight, other.greenLight, t),
      green: Color.lerp(green, other.green, t),
      white: Color.lerp(white, other.white, t),
      orange: Color.lerp(orange, other.orange, t),
      violetLight: Color.lerp(violetLight, other.violetLight, t),
      grey: Color.lerp(grey, other.grey, t),
      greyDark: Color.lerp(greyDark, other.greyDark, t),
      pink: Color.lerp(pink, other.pink, t),
      violet: Color.lerp(violet, other.violet, t),
    );
  }
}

class AppThemes {
  const AppThemes._();

  static ThemeData light2() {
    return ThemeData(
      primarySwatch: Colors.blue,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black.withOpacity(0),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        onSecondaryContainer: const Color(0xFFFF5106),
        tertiary: const Color(0xFFFF5106),
        tertiaryContainer: const Color(0xFFFF5106),
        onTertiaryContainer: const Color(0xFFFF5106),
        // free
        error: const Color(0xFFFF5106),
        // free
        onError: const Color(0xFFFF5106),
        // free
        errorContainer: const Color(0xFFFF5106),
        // free
        onErrorContainer: const Color(0xFFFF5106),
        // free
        background: const Color(0xFFFF5106),
        onBackground: const Color(0xFFFF5106),
        surface: const Color(0xFFFF5106),
        onSurface: const Color(0xFFFF5106),
        surfaceVariant: const Color(0xFFFF5106),
        onSurfaceVariant: const Color(0xFFFF5106),
        outline: const Color(0xFFFF5106),
        outlineVariant: const Color(0xFFFF5106),
        shadow: const Color(0xFFFF5106),
        // free
        scrim: const Color(0xFFFF5106),
        inverseSurface: const Color(0xFFFF5106),
        onInverseSurface: const Color(0xFFFF5106),
        inversePrimary: const Color(0xFFFF5106),
        surfaceTint: const Color(0xFFFF5106),
        onSecondary: const Color(0xFFFF5106),
        primary: const Color(0xFFFF5106),
        onPrimary: const Color(0xFFFF5106),
        secondary: const Color(0xFFFF5106),
        secondaryContainer: const Color(0xFFFF5106),
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
      canvasColor: Colors.transparent,
      textTheme: const TextTheme(
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
        titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF858597),
        ),
        titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF858597),
            wordSpacing: 1.0),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB8B8D2), // title under SignUp
        ),
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
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF858597),
          letterSpacing: 0.1,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFFFFFFF),
          letterSpacing: 0.1,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1F1F39),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      colorScheme: const ColorScheme.light().copyWith(
        onSecondary: const Color(0xFFFFFFFF),
        onSecondaryContainer: const Color(0xFF1F1F39),
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
      extensions: const <ThemeExtension<AppColors>>[
        AppColors(
          redLight: Color(0xFFFFE7EE),
          blueLight: Color(0xFFBAD6FF),
          greenLight: Color(0xFFBAE0DB),
          red: Color(0xFFEC7B9C),
          blue: Color(0xFF3D5CFF),
          green: Color(0xFF398A80),
          white: Color(0xFFFFFFFF),
          orange: Color(0xFFFF6905),
          violetLight: Color(0xFFF4F3FD),
          grey: Color(0xFF858597),
          greyDark: Color(0xFF707070),
          pink: Color(0xFFEFE0FF),
          violet: Color(0xFF440687),
        ),
      ],
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        collapsedBackgroundColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF1F1F39),
        collapsedTextColor: Color(0xFF1F1F39),
        iconColor: Color(0xFF1F1F39),
        collapsedIconColor: Color(0xFF1F1F39),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
        expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: Color(0xFF1F1F39),
          collapsedBackgroundColor: Color(0xFF1F1F39),
          textColor: Color(0xFFB8B8D2),
          collapsedTextColor: Color(0xFFB8B8D2),
          iconColor: Color(0xFFB8B8D2),
          collapsedIconColor: Color(0xFFB8B8D2),
        ),
        extensions: const <ThemeExtension<AppColors>>[
          AppColors(
            redLight: Color(0xFF2F2F42),
            blueLight: Color(0xFF2F2F42),
            greenLight: Color(0xFF2F2F42),
            red: Color(0xFFEC7B9C),
            blue: Color(0xFF3D5CFF),
            green: Color(0xFF398A80),
            white: Color(0xFFFFFFFF),
            orange: Color(0xFFFF6905),
            violetLight: Color(0xFFF4F3FD),
            grey: Color(0xFFB8B8D2),
            greyDark: Color(0xFF707070),
            pink: Color(0xFFEFE0FF),
            violet: Color(0xFF440687),
          ),
        ],
        fontFamily: AppFonts.fontFamily,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1F1F39),
        colorScheme: const ColorScheme.dark().copyWith(
          onSecondary: const Color(0xFFFFFFFF).withOpacity(0.3),
          onSecondaryContainer: const Color(0xFFB8B8D2),
          background: const Color(0xFF1F1F39),
          onBackground: const Color(0xFFEAEAFF),
          primary: const Color(0xFF3D5CFF),
          onPrimary: const Color(0xFF858597),
          secondary: const Color(0xFFEAEAFF),
          secondaryContainer: const Color(0xFFEAEAFF),
          tertiary: const Color(0xFF1F1F39),
          tertiaryContainer: const Color(0xFFFF5106),
          outline: const Color(0xFF3E3E55),
          outlineVariant: const Color(0xFFB8B8D2),
          surface: const Color(0xFF2F2F42),
          onSurface: const Color(0xFF3E3E55),
          scrim: const Color(0xFFB8B8D2),
          inverseSurface: const Color(0xFF3E3E55),
          onInverseSurface: const Color(0xFF2F2F42),
          surfaceVariant: const Color(0xFFFFFFFF),
          onSurfaceVariant: const Color(0xFF3D5CFF),
          surfaceTint: const Color(0xFF858597),
          inversePrimary: const Color(0xFFFFEBF0),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFFFFFFF),
          selectionColor: Color(0xFFB8B8D2),
          selectionHandleColor: Color(0xFFB8B8D2),
        ),
        textTheme: const TextTheme(
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
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF), // text in button1
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF4F3FD),
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB8B8D2), // title under SignUp
          ),
          titleLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB8B8D2),
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
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF4F3FD),
            letterSpacing: 0.1,
            height: 1.5,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFFFF),
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
