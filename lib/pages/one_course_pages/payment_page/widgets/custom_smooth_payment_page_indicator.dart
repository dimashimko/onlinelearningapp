import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSmoothPaymentPageIndicator extends StatelessWidget {
  const CustomSmoothPaymentPageIndicator({
    required this.cardController,
    required this.length,
    super.key,
  });

  final PageController cardController;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SmoothPageIndicator(
          controller: cardController,
          count: length,
          effect: SlideEffect(
            spacing: 8.0,
            radius: 6.0,
            dotWidth: 8.0,
            dotHeight: 8.0,
            paintStyle: PaintingStyle.fill,
            dotColor: colors(context).violetLight ?? Colors.grey,
            activeDotColor: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
