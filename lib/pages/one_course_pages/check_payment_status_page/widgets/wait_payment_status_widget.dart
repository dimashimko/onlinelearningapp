import 'package:flutter/material.dart';

class WaitPaymentStatusWidget extends StatelessWidget {
  const WaitPaymentStatusWidget({
    required this.counterState,
    Key? key,
  }) : super(key: key);

  final int counterState;

  @override
  Widget build(BuildContext context) {
    int numberOfPoint = counterState % 3 + 1;

    List<String> points = List.generate(numberOfPoint, (index) => '.');
    return SizedBox(
      width: 200,
      child: Text(
        'Payment is pending ${points.join().padRight(3 - numberOfPoint, ' ')}',
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }
}
