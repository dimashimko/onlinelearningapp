import 'package:flutter/material.dart';

AppColors colors(context) => Theme.of(context).extension<AppColors>()!;

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        red_light: isDarkTheme ? Colors.blue : Colors.green,
        blue_light: isDarkTheme ? Colors.pink : Colors.blue,
        green_light: isDarkTheme ? Colors.yellow : Colors.red,
      ),
    ],
    scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
    textTheme: Theme.of(context)
        .textTheme
        .copyWith(
      titleSmall:
      Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
    )
        .apply(
      bodyColor: isDarkTheme ? Colors.white : Colors.black,
      displayColor: Colors.grey,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(
          isDarkTheme ? Colors.orange : Colors.purple),
    ),
    listTileTheme: ListTileThemeData(
        iconColor: isDarkTheme ? Colors.orange : Colors.purple),
    appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
        iconTheme:
        IconThemeData(color: isDarkTheme ? Colors.white : Colors.black54)),
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color? red_light;
  final Color? blue_light;
  final Color? green_light;

  const AppColors({
    required this.red_light,
    required this.blue_light,
    required this.green_light,
  });

  @override
  AppColors copyWith({
    Color? red_light,
    Color? blue_light,
    Color? green_light,
  }) {
    return AppColors(
      red_light: red_light ?? this.red_light,
      blue_light: blue_light ?? this.blue_light,
      green_light: green_light ?? this.green_light,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      red_light: Color.lerp(red_light, other.red_light, t),
      blue_light: Color.lerp(blue_light, other.blue_light, t),
      green_light: Color.lerp(green_light, other.green_light, t),
    );
  }
}