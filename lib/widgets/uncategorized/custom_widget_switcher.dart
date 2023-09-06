import 'package:flutter/material.dart';

class CustomWidgetSwitcher extends StatelessWidget {
  const CustomWidgetSwitcher({
    required this.isEnable,
    required this.child,
    super.key,
  });

  final bool isEnable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AbsorbPointer(
        absorbing: !isEnable,
        child: child,
      ),
      if (!isEnable)
        Positioned.fill(
          child: Material(
            color: Theme.of(context).colorScheme.surface.withAlpha(200),
          ),
        ),
    ]);
  }
}