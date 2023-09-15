// set up the AlertDialog
import 'package:flutter/material.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clocking in!",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 24.0,
                ),
          ),
          Text(
            "GOOD JOB!",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      content: Text("This is my message."),
      actions: [
        shareButton,
      ],
    );
  }
}

Widget shareButton = CustomButton(
  title: 'Share',
  onTap: () {},
);
