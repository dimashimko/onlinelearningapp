import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/uncategorized/splash_box.dart';

class StarButton extends StatelessWidget {
  const StarButton({
    Key? key,
    required this.isEnable,
    this.borderRadius = 12.0,
    this.padding = 0.0,
    required this.onTap,
  }) : super(key: key);

  final bool isEnable;
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
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: isEnable
                ? SvgPicture.asset(AppIcons.starFilled)
                : SvgPicture.asset(AppIcons.starEmpty),
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
