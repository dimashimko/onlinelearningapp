import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({
    required this.onTapButtonBack,
    super.key,
  });

  final VoidCallback onTapButtonBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapButtonBack(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SvgPicture.asset(
          AppIcons.arrowBack,
        ),
      ),
    );
  }
}
