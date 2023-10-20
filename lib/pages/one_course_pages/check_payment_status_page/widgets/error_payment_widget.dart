import 'package:flutter/material.dart';
import 'package:online_learning_app/models/payment_status_model/payment_status_model.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';

class ErrorPaymentWidget extends StatelessWidget {
  const ErrorPaymentWidget({
    required this.customPaymentStatus,
    required this.goToBackPage,
    super.key,
  });

  final CustomPaymentStatus customPaymentStatus;
  final VoidCallback goToBackPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'An error occurred during payment',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const Text('Error description:'),
        Text(customPaymentStatus.description),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            title: 'Return',
            onTap: goToBackPage,
          ),
        )
      ],
    );
  }
}
