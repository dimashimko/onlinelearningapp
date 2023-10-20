import 'package:flutter/material.dart';

class CustomLinearGradientLine extends StatelessWidget {
  const CustomLinearGradientLine({
    required this.sec,
    super.key,
  });

  final int sec;

  @override
  Widget build(BuildContext context) {
    int minRounded = sec > 3600 ? 60 : sec ~/ 60;
    return Stack(
      children: [
        Container(
          height: 6.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        Container(
          height: 6.0,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment(((minRounded * 2) / 60) - 1, 0.0),
              colors: <Color>[
                Theme.of(context).colorScheme.onSecondary,
                Theme.of(context).colorScheme.tertiaryContainer,
              ],
              tileMode: TileMode.decal,
            ),
          ),
        ),
      ],
    );
  }
}
