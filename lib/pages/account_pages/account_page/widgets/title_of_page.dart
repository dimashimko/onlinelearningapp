import 'package:flutter/material.dart';

class TitleOfPage extends StatelessWidget {
  const TitleOfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Account',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: 24.0,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
