import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class CustomNotificationTabBar extends StatelessWidget {
  const CustomNotificationTabBar({
    required this.name,
    required this.hasNew,
    super.key,
  });

  final String name;
  final bool hasNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        hasNew
            ? SvgPicture.asset(
          AppIcons.pointOrange,
        )
            : const SizedBox(height: 6.0),
        Text(
          name,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
