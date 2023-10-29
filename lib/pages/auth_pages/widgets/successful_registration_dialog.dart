import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';

class SuccessRegistrationDialog extends StatelessWidget {
  const SuccessRegistrationDialog({
    required this.onTapDone,
    super.key,
  });

  final VoidCallback onTapDone;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16.0),
          SvgPicture.asset(
            AppIcons.checkMark,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Success',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Congratulations, you have completed your registration!',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
        ],
      ),
      actions: [
        CustomButton(
          title: 'Done',
          onTap: onTapDone,
        ),
      ],
    );
  }
}
