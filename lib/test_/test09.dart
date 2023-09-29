import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rounded Button with Arch'),
        ),
        body: Center(
          child: RoundedButtonWithArch(),
        ),
      ),
    ),
  );
}

class RoundedButtonWithArch extends StatefulWidget {
  @override
  State<RoundedButtonWithArch> createState() => _RoundedButtonWithArchState();
}

class _RoundedButtonWithArchState extends State<RoundedButtonWithArch> {
  static const double size = 100.0;
  static const double borderPercent = 10;
  static const double borderSize = size / 100 * borderPercent;
  static const double circleSize = size - borderSize;

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: size,
                height: size,
                child: ClipOval(
                  child: Container(
                    color: Colors.blue, // Change the color as needed
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: Size(size, size),
              painter: ArchPainter(angle: 70),
            ),
            Center(
              child: Container(
                width: circleSize,
                height: circleSize,
                child: ClipOval(
                  child: Container(
                    color: Colors.blue, // Change the color as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchPainter extends CustomPainter {
  // ArchPainter(double angle){}
  ArchPainter({
    required this.angle,
  });

  final double angle;


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange // Change the color as needed
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

/*    Path path = Path();
    path.moveTo(centerX - radius, centerY);
    path.quadraticBezierTo(
        centerX, centerY - radius * 2, centerX + radius, centerY);*/

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: size.width / 2),
      -pi / 2,
      pi * 2 / 100 * angle,
      true,
      paint,
    );

    // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
