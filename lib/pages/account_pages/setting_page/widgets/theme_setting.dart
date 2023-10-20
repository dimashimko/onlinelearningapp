import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/themes/app_themes.dart';
import 'package:online_learning_app/resources/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Theme:',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const Spacer(),
        const SizedBox(height: 8.0),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Switch.adaptive(
              value: themeProvider.currentTheme == AppThemes.dark(),
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: colors(context).violetLight,
              activeTrackColor: colors(context).blue,
              inactiveThumbColor: colors(context).violetLight,
              inactiveTrackColor: colors(context).greyDark,
            );
          },
        ),
      ],
    );
  }
}
