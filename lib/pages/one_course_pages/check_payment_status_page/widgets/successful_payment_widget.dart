import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';

class SuccessfulPaymentWidget extends StatelessWidget {
  const SuccessfulPaymentWidget({
    required this.goToCoursePage,
    super.key,
  });

  final VoidCallback goToCoursePage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(AppIcons.checkMark3),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Successful purchase!',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        CustomButton(
          title: 'Start learning',
          onTap: () {
            goToCoursePage();
          },
        ),
      ],
    );
  }
}
