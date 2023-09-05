import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';

class PriceFilterSlider extends StatefulWidget {
  const PriceFilterSlider({
    required this.initRangeValues,
    super.key,
  });

  final RangeValues initRangeValues;

  @override
  State<PriceFilterSlider> createState() => _PriceFilterSliderState();
}

class _PriceFilterSliderState extends State<PriceFilterSlider> {
  RangeValues _currentRangeValues = RangeValues(0, 10);

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.initRangeValues;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 1,
        activeTrackColor: Theme.of(context).colorScheme.primary,
        inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
        thumbColor: Theme.of(context).colorScheme.onSurfaceVariant,
        overlayColor: Colors.transparent,
        overlappingShapeStrokeColor:
            Theme.of(context).colorScheme.surfaceVariant,
        //
        //
        // rangeThumbShape: CustomRangeThumbShape3(),
        // showValueIndicator: ShowValueIndicator.always,
        // valueIndicatorTextStyle: TextStyle(
        //   color: Theme.of(context).colorScheme.onBackground,
        // ),
        // rangeValueIndicatorShape: const CustomValueIndicatorShape2(),


        rangeThumbShape: CustomRangeThumbShape5(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          currentRangeValues: _currentRangeValues,
        ),
      ),
      child: RangeSlider(
        values: _currentRangeValues,
        max: context.read<CoursesBloc>().state.maxPricePerCourse,
        onChanged: (RangeValues values) {
          setState(() {
            _currentRangeValues = values;
            context.read<CoursesBloc>().add(
                  ChangePriceFilter(
                    currentRangeValues: _currentRangeValues,
                  ),
                );
          });
        },
        labels: RangeLabels(
          _currentRangeValues.start.round().toDouble().toString(),
          _currentRangeValues.end.round().toDouble().toString(),
        ),
      ),
    );
  }
}

class CustomRangeThumbShape5 extends RangeSliderThumbShape {
  final TextStyle textStyle;
  final RangeValues currentRangeValues;
  final double verticalPadding;
  final double thumbRadius;
  final double borderThickness;

  CustomRangeThumbShape5({
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
      // ..color = fillColor
      ..color = sliderTheme?.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      // ..color = borderColor
      ..color = sliderTheme?.overlappingShapeStrokeColor ?? Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;

    context.canvas.drawCircle(center, thumbRadius, fillPaint);
    context.canvas
        .drawCircle(center, thumbRadius - borderThickness / 2, borderPaint);
  }
}

class CustomRangeThumbShape3 extends RangeSliderThumbShape {
  final double thumbRadius;
  final double borderThickness;

  CustomRangeThumbShape3({
    this.thumbRadius = 10.0,
    this.borderThickness = 2.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
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
    final canvas = context.canvas;

    final fillPaint = Paint()
      // ..color = fillColor
      ..color = sliderTheme?.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      // ..color = borderColor
      ..color = sliderTheme?.overlappingShapeStrokeColor ?? Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius - borderThickness / 2, borderPaint);
  }
}

class CustomValueIndicatorShape2 extends RangeSliderValueIndicatorShape {
  const CustomValueIndicatorShape2();

  static const _CustomSliderValueIndicatorPathPainter2 _pathPainter =
      _CustomSliderValueIndicatorPathPainter2();

  @override
  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    required TextPainter labelPainter,
    required double textScaleFactor,
  }) {
    assert(textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter, textScaleFactor);
  }

  @override
  double getHorizontalShift({
    RenderBox? parentBox,
    Offset? center,
    TextPainter? labelPainter,
    Animation<double>? activationAnimation,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    return _pathPainter.getHorizontalShift(
      parentBox: parentBox!,
      center: center!,
      labelPainter: labelPainter!,
      textScaleFactor: textScaleFactor!,
      sizeWithOverflow: sizeWithOverflow!,
      scale: activationAnimation!.value,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isOnTop,
    TextPainter? labelPainter,
    double? textScaleFactor,
    Size? sizeWithOverflow,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation!.value;
    _pathPainter.paint(
      parentBox: parentBox!,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter!,
      textScaleFactor: textScaleFactor!,
      sizeWithOverflow: sizeWithOverflow!,
      backgroundPaintColor: sliderTheme!.valueIndicatorColor!,
      strokePaintColor: null,
    );
  }
}

class _CustomSliderValueIndicatorPathPainter2 {
  const _CustomSliderValueIndicatorPathPainter2();

  static const double _triangleHeight = 8.0;
  static const double _labelPadding = 16.0;
  static const double _preferredHeight = 32.0;
  static const double _minLabelWidth = 16.0;
  static const double _bottomTipYOffset = 14.0;
  static const double _preferredHalfHeight = _preferredHeight / 2;
  static const double _upperRectRadius = 8;
  static const double _horizontalPadding = 24;

  Size getPreferredSize(
    TextPainter labelPainter,
    double textScaleFactor,
  ) {
    return Size(
      _upperRectangleWidth(labelPainter, 1, textScaleFactor),
      labelPainter.height + _labelPadding,
    );
  }

  double getHorizontalShift({
    required RenderBox parentBox,
    required Offset center,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required double scale,
  }) {
    assert(!sizeWithOverflow.isEmpty);

    const double edgePadding = 8.0;
    final double rectangleWidth =
        _upperRectangleWidth(labelPainter, scale, textScaleFactor);
    final Offset globalCenter = parentBox.localToGlobal(center);
    final double overflowLeft =
        math.max(0, rectangleWidth / 2 - globalCenter.dx + edgePadding);
    final double overflowRight = math.max(
        0,
        rectangleWidth / 2 -
            (sizeWithOverflow.width - globalCenter.dx - edgePadding));

    if (rectangleWidth < sizeWithOverflow.width) {
      return overflowLeft - overflowRight;
    } else if (overflowLeft - overflowRight > 0) {
      return overflowLeft - (edgePadding * textScaleFactor);
    } else {
      return -overflowRight + (edgePadding * textScaleFactor);
    }
  }

  double _upperRectangleWidth(
      TextPainter labelPainter, double scale, double textScaleFactor) {
    final double unscaledWidth =
        math.max(_minLabelWidth * textScaleFactor, labelPainter.width) +
            _labelPadding * 2;
    return unscaledWidth * scale;
  }

  void paint({
    required RenderBox parentBox,
    required Canvas canvas,
    required Offset center,
    required double scale,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required Color backgroundPaintColor,
    Color? strokePaintColor,
  }) {
    if (scale == 0.0) {
      return;
    }
    assert(!sizeWithOverflow.isEmpty);

    final double rectangleWidth =
        _upperRectangleWidth(labelPainter, scale, textScaleFactor);
    final double horizontalShift = getHorizontalShift(
      parentBox: parentBox,
      center: center,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      scale: scale,
    );

    final double rectHeight = labelPainter.height + _labelPadding;
    final Rect upperRect = Rect.fromLTWH(
      -rectangleWidth / 2 - horizontalShift,
      -_triangleHeight - rectHeight,
      rectangleWidth,
      rectHeight,
    );

    // final Path trianglePath = Path()
    //   ..lineTo(-_triangleHeight, -_triangleHeight)
    //   ..lineTo(_triangleHeight, -_triangleHeight)
    //   ..close();
    // final Paint fillPaint = Paint()..color = backgroundPaintColor;
    // final RRect upperRRect = RRect.fromRectAndRadius(
    //     upperRect, const Radius.circular(_upperRectRadius));
    // trianglePath.addRRect(upperRRect);

    canvas.save();
    canvas.translate(center.dx, center.dy - _bottomTipYOffset);
    canvas.scale(scale, scale);
    // canvas.drawShadow(
    //     trianglePath, const Color.fromARGB(40, 24, 40, 13), 4, true);
    // if (strokePaintColor != null) {
    //   final Paint strokePaint = Paint()
    //     ..color = strokePaintColor
    //     ..strokeWidth = 1.0
    //     ..style = PaintingStyle.stroke;
    //   canvas.drawPath(trianglePath, strokePaint);
    // }
    // canvas.drawPath(trianglePath, fillPaint);

    // final double bottomTipToUpperRectTranslateY =
    //     -_preferredHalfHeight / 2 + upperRect.height;
    // canvas.translate(0, bottomTipToUpperRectTranslateY);

    canvas.translate(0, _horizontalPadding);

    final Offset boxCenter = Offset(horizontalShift, upperRect.height / 2);
    final Offset halfLabelPainterOffset =
        Offset(labelPainter.width / 2, labelPainter.height / 2);
    final Offset labelOffset = boxCenter + -halfLabelPainterOffset;
    labelPainter.paint(canvas, labelOffset);
    canvas.restore();
  }
}

// ****************************************************************************
// ************************************
class CustomRangeSliderValueIndicatorShape
    extends RangeSliderValueIndicatorShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete,
      {required TextPainter labelPainter, required double textScaleFactor}) {
    // TODO: implement getPreferredSize
    throw UnimplementedError();
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isOnTop,
    required TextPainter labelPainter,
    double? textScaleFactor,
    Size? sizeWithOverflow,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    double? value,
    Thumb? thumb,
  }) {
    // TODO: implement paint
  }
}

class CustomRangeThumbShape extends RangeSliderThumbShape {
  const CustomRangeThumbShape();

  static const double _thumbSize = 4;
  static const double _disabledThumbSize = 3;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final canvas = context.canvas;
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final size = _thumbSize * sizeTween.evaluate(enableAnimation);
    Path thumbPath;
    switch (textDirection!) {
      case TextDirection.rtl:
        switch (thumb!) {
          case Thumb.start:
            thumbPath = _rightTriangle(size, center);
            break;
          case Thumb.end:
            thumbPath = _leftTriangle(size, center);
            break;
        }
        break;
      case TextDirection.ltr:
        switch (thumb!) {
          case Thumb.start:
            thumbPath = _leftTriangle(size, center);
            break;
          case Thumb.end:
            thumbPath = _rightTriangle(size, center);
            break;
        }
        break;
    }
    canvas.drawPath(
      thumbPath,
      Paint()..color = colorTween.evaluate(enableAnimation)!,
    );
  }
}

Path _downTriangle(double size, Offset thumbCenter, {bool invert = false}) {
  final thumbPath = Path();
  final height = math.sqrt(3) / 2;
  final centerHeight = size * height / 3;
  final halfSize = size / 2;
  final sign = invert ? -1 : 1;
  thumbPath.moveTo(
      thumbCenter.dx - halfSize, thumbCenter.dy + sign * centerHeight);
  thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - 2 * sign * centerHeight);
  thumbPath.lineTo(
      thumbCenter.dx + halfSize, thumbCenter.dy + sign * centerHeight);
  thumbPath.close();
  return thumbPath;
}

Path _rightTriangle(double size, Offset thumbCenter, {bool invert = false}) {
  final thumbPath = Path();
  final halfSize = size / 2;
  final sign = invert ? -1 : 1;
  thumbPath.moveTo(thumbCenter.dx + halfSize * sign, thumbCenter.dy);
  thumbPath.lineTo(thumbCenter.dx - halfSize * sign, thumbCenter.dy - size);
  thumbPath.lineTo(thumbCenter.dx - halfSize * sign, thumbCenter.dy + size);
  thumbPath.close();
  return thumbPath;
}

Path _upTriangle(double size, Offset thumbCenter) =>
    _downTriangle(size, thumbCenter, invert: true);

Path _leftTriangle(double size, Offset thumbCenter) =>
    _rightTriangle(size, thumbCenter, invert: true);

// class CustomRangeThumbShape2 extends RangeSliderThumbShape {
//
//   static const double _thumbSize = 4;
//   static const double _disabledThumbSize = 3;
//
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return isEnabled
//         ? const Size.fromRadius(_thumbSize)
//         : const Size.fromRadius(_disabledThumbSize);
//   }
//
//   static final Animatable<double> sizeTween = Tween<double>(
//     begin: _disabledThumbSize,
//     end: _thumbSize,
//   );
//
//   @override
//   void paint(
//       PaintingContext context,
//       Offset center, {
//         required Animation<double> activationAnimation,
//         required Animation<double> enableAnimation,
//         bool isDiscrete = false,
//         bool isEnabled = false,
//         bool? isOnTop,
//         TextDirection? textDirection,
//         required SliderThemeData sliderTheme,
//         Thumb? thumb,
//         bool? isPressed,
//       }) {
//     // final canvas = context.canvas;
//     // final colorTween = ColorTween(
//     //   begin: sliderTheme.disabledThumbColor,
//     //   end: sliderTheme.thumbColor,
//     // );
//     //
//     // final size = _thumbSize * sizeTween.evaluate(enableAnimation);
//     //
//     //
//     // Path _circleThumb(double size, Offset thumbCenter, {bool invert = false}) {
//     //   final Path thumbPath = Path();
//     //   final double halfSize = size / 2;
//     //   final int sign = invert ? -1 : 1;
//     //   thumbPath.moveTo(thumbCenter.dx + halfSize * sign, thumbCenter.dy);
//     //   thumbPath.lineTo(thumbCenter.dx - halfSize * sign, thumbCenter.dy - size);
//     //   thumbPath.lineTo(thumbCenter.dx - halfSize * sign, thumbCenter.dy + size);
//     //   thumbPath.close();
//     //   return thumbPath;
//     // }
//     // Path thumbPath;
//     // Path thumbPath2 = _circleThumb(size, center);
//     //
//     // canvas.drawPath(
//     //   // thumbPath,
//     //   thumbPath2,
//     //   Paint()..color = colorTween.evaluate(enableAnimation)!,
//     // );
//
//
//   }
// }

//
// class _ThumbShape extends RoundSliderThumbShape {
//   final _indicatorShape = const PaddleSliderValueIndicatorShape();
//
//   @override
//   void paint(
//       PaintingContext context,
//       Offset center, {
//         required Animation<double> activationAnimation,
//         required Animation<double> enableAnimation,
//         required bool isDiscrete,
//         required TextPainter labelPainter,
//         required RenderBox parentBox,
//         required SliderThemeData sliderTheme,
//         required TextDirection textDirection,
//         required double value,
//         required double textScaleFactor,
//         required Size sizeWithOverflow,
//       }) {
//     super.paint(
//       context,
//       center,
//       activationAnimation: activationAnimation,
//       enableAnimation: enableAnimation,
//       sliderTheme: sliderTheme,
//       value: value,
//       textScaleFactor: textScaleFactor,
//       sizeWithOverflow: sizeWithOverflow,
//       isDiscrete: isDiscrete,
//       labelPainter: labelPainter,
//       parentBox: parentBox,
//       textDirection: textDirection,
//     );
//     _indicatorShape.paint(
//       context,
//       center,
//       activationAnimation: const AlwaysStoppedAnimation(1),
//       enableAnimation: enableAnimation,
//       labelPainter: labelPainter,
//       parentBox: parentBox,
//       sliderTheme: sliderTheme,
//       value: value,
// // test different testScaleFactor to find your best fit
//       textScaleFactor: 0.6,
//       sizeWithOverflow: sizeWithOverflow,
//       isDiscrete: isDiscrete,
//       textDirection: textDirection,
//     );
//   }
// }
