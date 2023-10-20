import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/widgets/sliders/custom_range_thumb_shape.dart';

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
            rangeThumbShape: CustomRangeThumbShape(
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

