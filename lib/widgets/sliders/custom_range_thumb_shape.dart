import 'package:flutter/material.dart';

class CustomRangeThumbShape extends RangeSliderThumbShape {
  final TextStyle textStyle;
  final RangeValues currentRangeValues;
  final double verticalPadding;
  final double thumbRadius;
  final double borderThickness;

  CustomRangeThumbShape({
    required this.textStyle,
    required this.currentRangeValues,
    this.verticalPadding = 24.0,
    this.thumbRadius = 10.0,
    this.borderThickness = 2.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    final textPainter = TextPainter(
      text: TextSpan(text: '', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    double width = textPainter.width + 16.0; // Add padding for the thumb
    double height = textPainter.height;
    return Size(width, height + verticalPadding);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double>? activationAnimation,
        Animation<double>? enableAnimation,
        bool? isDiscrete,
        bool? isEnabled,
        bool? isOnTop,
        TextDirection? textDirection,
        SliderThemeData? sliderTheme,
        Thumb? thumb,
        bool? isPressed,
      }) {
    String text = '';
    switch (thumb!) {
      case Thumb.start:
        text = '\$${currentRangeValues.start.round()}';
        break;
      case Thumb.end:
        text = '\$${currentRangeValues.end.round()}';
        break;
    }

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: textDirection,
    );
    textPainter.layout();

    textPainter.paint(
      context.canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2 + verticalPadding,
      ),
    );

    final fillPaint = Paint()
      ..color = sliderTheme?.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme?.overlappingShapeStrokeColor ?? Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;

    context.canvas.drawCircle(center, thumbRadius, fillPaint);
    context.canvas
        .drawCircle(center, thumbRadius - borderThickness / 2, borderPaint);
  }
}
