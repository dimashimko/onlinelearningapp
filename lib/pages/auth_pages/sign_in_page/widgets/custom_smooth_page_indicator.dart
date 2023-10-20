import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({
    required this.imageController,
    required this.length,
    super.key,
  });

  final PageController imageController;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SmoothPageIndicator(
          controller: imageController,
          count: length,
          effect: ExpandingDotsEffect(
            spacing: 12.0,
            radius: 4.0,
            dotWidth: 12.0,
            dotHeight: 6.0,
            paintStyle: PaintingStyle.fill,
            activeDotColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
