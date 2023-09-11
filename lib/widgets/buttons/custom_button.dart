import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/uncategorized/splash_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    this.borderRadius = 12.0,
    this.padding = 0.0,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final double borderRadius;
  final double padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Container(
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SplashBox(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
        ),
      ],
    );
  }
}
