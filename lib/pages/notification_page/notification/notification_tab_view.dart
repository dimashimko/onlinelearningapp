import 'package:flutter/material.dart';

class NotificationTabView extends StatelessWidget {
  const NotificationTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Placeholder(),
          Placeholder(),
          Placeholder(),
          Text(
            'NotificationTab',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 24.0,
            ),
          ),        Text(
            'NotificationTab',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 24.0,
            ),
          ),

        ],
      ),
    );
  }
}
