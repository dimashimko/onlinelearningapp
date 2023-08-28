import 'package:flutter/material.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';

class PriceFilterSliderFromGit extends StatefulWidget {
  const PriceFilterSliderFromGit({super.key});

  @override
  State<PriceFilterSliderFromGit> createState() =>
      _PriceFilterSliderFromGitState();
}

class _PriceFilterSliderFromGitState extends State<PriceFilterSliderFromGit> {
  double _lowerValue = 0.0;
  double _upperValue = 200.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: RangeSliderFlutter(
        // key: Key('3343'),
        values: [_lowerValue, _upperValue],
        rangeSlider: true,
        tooltip: RangeSliderFlutterTooltip(
          alwaysShowTooltip: true,
        ),
        max: 300,
        // textPositionTop: 50,
        textPositionBottom: -150,
        handlerHeight: 30,
        trackBar: RangeSliderFlutterTrackBar(
          activeTrackBarHeight: 2,
          inactiveTrackBarHeight: 2,
          activeTrackBar: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0),
            color: Colors.red,
          ),
          inactiveTrackBar: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),

        min: 0,
        fontSize: 15,
        textBackgroundColor: Colors.red,
        onDragging: (handlerIndex, lowerValue, upperValue) {
          _lowerValue = lowerValue;
          _upperValue = upperValue;
          setState(() {});
        },
      ),
    );
  }
}
