import 'package:flutter/material.dart';

class MessageTabView extends StatelessWidget {
  const MessageTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'MessageTab',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 24.0,
                ),
          ),
          Text(
            'MessageTab',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 24.0,
                ),
          ),
          Text(
            'MessageTab',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 24.0,
                ),
          ),
        ],
      ),
    );
  }
}
