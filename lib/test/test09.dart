// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_range_slider/flutter_range_slider.dart' as RangeSlider;
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RangeSliderExample(),
//     );
//   }
// }
//
// class RangeSliderExample extends StatefulWidget {
//   @override
//   _RangeSliderExampleState createState() => _RangeSliderExampleState();
// }
//
// class _RangeSliderExampleState extends State<RangeSliderExample> {
//   double _startValue = 20;
//   double _endValue = 80;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Range Slider Example')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             RangeSlider(
//               min: 0,
//               max: 100,
//               lowerValue: _startValue,
//               upperValue: _endValue,
//               onChanged: (double newStartValue, double newEndValue) {
//                 setState(() {
//                   _startValue = newStartValue;
//                   _endValue = newEndValue;
//                 });
//               },
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Start: $_startValue | End: $_endValue',
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
