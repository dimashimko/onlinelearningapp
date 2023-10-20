import 'package:flutter/material.dart';

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