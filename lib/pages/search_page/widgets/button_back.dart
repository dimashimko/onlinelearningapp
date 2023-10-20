import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class ButtonBackSearchPage extends StatelessWidget {
  const ButtonBackSearchPage({
    required this.goToBackPage,
    super.key,
  });

  final VoidCallback goToBackPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SvgPicture.asset(
          AppIcons.arrowBack,
        ),
      ),
      onTap: () => goToBackPage(),
    );
  }
}
