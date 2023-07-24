import 'package:flutter/material.dart';

class CustomErrorText extends StatelessWidget {
  const CustomErrorText({
    required this.errorText,
    Key? key,
  }) : super(key: key);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        errorText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color(0xFFdb667b),
            ),
      ),
    );
  }
}
