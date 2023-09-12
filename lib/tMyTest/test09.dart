import 'package:flutter/material.dart';

class RoundedButtonWithArch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            ClipOval(
              child: Container(
                color: Colors.blue, // Change the color as needed
              ),
            ),
            CustomPaint(
              size: Size(150, 150),
              painter: ArchPainter(),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange // Change the color as needed
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

/*    Path path = Path();
    path.moveTo(centerX - radius, centerY);
    path.quadraticBezierTo(
        centerX, centerY - radius * 2, centerX + radius, centerY);*/

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(centerX, centerY),
          radius: size.width / 3),
      3.14,
      3.14,
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

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Rounded Button with Arch'),
      ),
      body: Center(
        child: RoundedButtonWithArch(),
      ),
    ),
  ));
}
