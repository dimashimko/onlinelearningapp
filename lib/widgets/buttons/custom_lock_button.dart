import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class CustomLockButton extends StatelessWidget {
  const CustomLockButton({
    Key? key,
    this.padding = 0.0,
    this.buttonRadius = 44.0,
    required this.onTap,
  }) : super(key: key);

  final double padding;
  final double buttonRadius;
  final VoidCallback onTap;

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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(buttonRadius / 2),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppIcons.lock,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
