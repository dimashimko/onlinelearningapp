import 'package:flutter/material.dart';
import 'package:online_learning_app/utils/constants.dart';

class SlideTransitionAnimation extends StatefulWidget {
  const SlideTransitionAnimation({
    Key? key,
    this.curve = kCurveAnimations,
    this.duration = kAnimationDuration,
    this.placeholder,
    required this.child,
  }) : super(key: key);

  final Curve curve;
  final Duration duration;
  final Widget? placeholder;
  final Widget child;

  @override
  _SlideTransitionAnimationState createState() => _SlideTransitionAnimationState();
}

class _SlideTransitionAnimationState extends State<SlideTransitionAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setInitialData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setInitialData() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1), // Начальное положение виджета (сверху)
        end: Offset.zero, // Конечное положение виджета (начало координат)
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      ),
    );

    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.placeholder != null) widget.placeholder!,
        FadeTransition(
          opacity: _animation,
          child: widget.child,
        ),
      ],
    );
  }
}
