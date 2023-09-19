import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/uncategorized/splash_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPlayButton extends StatelessWidget {
  const CustomPlayButton({
    Key? key,
    this.padding = 0.0,
    this.buttonRadius = 44.0,
    this.color,
    required this.onTap,
  }) : super(key: key);

  final double padding;
  final double buttonRadius;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Container(
            width: buttonRadius,
            height: buttonRadius,
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(buttonRadius / 2),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(AppIcons.play),
          ),
        ),
        SplashBox(
          borderRadius: BorderRadius.circular(buttonRadius / 2),
          onTap: onTap,
        ),
      ],
    );
  }
}
