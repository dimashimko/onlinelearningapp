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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        return SliderTheme(
          data: SliderThemeData(
            trackHeight: 1,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
            thumbColor: Theme.of(context).colorScheme.onSurfaceVariant,
            overlayColor: Colors.transparent,
            overlappingShapeStrokeColor:
                Theme.of(context).colorScheme.surfaceVariant,
            rangeThumbShape: CustomRangeThumbShape5(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              currentRangeValues: state.filterPriceRangeValues,
            ),
          ),
          child: RangeSlider(
            values: state.filterPriceRangeValues,
            max: context.read<CoursesBloc>().state.maxPricePerCourse,
            onChanged: (RangeValues values) {
              setState(() {
                context.read<CoursesBloc>().add(
                      ChangePriceFilter(
                        currentRangeValues: values,
                      ),
                    );
              });
            },
            labels: RangeLabels(
              state.filterPriceRangeValues.start.round().toDouble().toString(),
              state.filterPriceRangeValues.end.round().toDouble().toString(),
            ),
          ),
        );
      },
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
