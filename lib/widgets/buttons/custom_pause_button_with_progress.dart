import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/uncategorized/splash_box.dart';

class CustomPauseButtonWithProgress extends StatefulWidget {
  const CustomPauseButtonWithProgress({
    Key? key,
    this.padding = 0.0,
    this.buttonSize = 44.0,
    required this.angle,
    required this.onTap,
  }) : super(key: key);

  final double padding;
  final double buttonSize;
  final double angle;
  final VoidCallback onTap;

  @override
  State<CustomPauseButtonWithProgress> createState() =>
      _CustomPauseButtonWithProgressState();
}

class _CustomPauseButtonWithProgressState
    extends State<CustomPauseButtonWithProgress> {
  late final double size;
  final double borderPercent = 10;
  late final double borderSize;
  late final double circleSize;

  @override
  void initState() {
    super.initState();
    size = widget.buttonSize;
    borderSize = size / 100 * borderPercent;
    circleSize = size - borderSize;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(widget.padding),
          child: Center(
            child: SizedBox(
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
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Change the color as needed
                        ),
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: Size(size, size),
                    painter: ArchPainter(
                      angle: widget.angle,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      child: ClipOval(
                        child: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Change the color as needed
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SvgPicture.asset(
                      AppIcons.pause,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SplashBox(
          borderRadius: BorderRadius.circular(widget.buttonSize / 2),
          onTap: widget.onTap,
        ),
      ],
    );
  }
}

class ArchPainter extends CustomPainter {

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

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
