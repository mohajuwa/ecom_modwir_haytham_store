import 'package:flutter/material.dart';

class CustomLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // You can tweak these to get the layout you want
    final double carWidth = size.width * 0.4;
    final double carHeight = size.height * 0.3;
    final double circleRadius = size.height * 0.15;
    final double circleCenterX =
        carWidth + circleRadius + 10; // offset from car
    final double circleCenterY = size.height * 0.4;

    // Paint objects
    final Paint blackPaint = Paint()..color = Colors.black;
    final Paint yellowPaint = Paint()..color = const Color(0xFFFFC107);

    // 1) Draw a simplified car silhouette (approx. shape)
    Path carPath = Path();
    carPath.moveTo(0, size.height * 0.6); // Start bottom-left
    carPath.quadraticBezierTo(
      carWidth * 0.3,
      size.height * 0.3,
      carWidth * 0.6,
      size.height * 0.6,
    );
    // roof
    carPath.lineTo(carWidth * 0.7, size.height * 0.6);
    carPath.quadraticBezierTo(
      carWidth * 0.9,
      size.height * 0.7,
      carWidth,
      size.height * 0.5,
    );
    // Down to bottom
    carPath.lineTo(carWidth, size.height * 0.8);
    carPath.lineTo(0, size.height * 0.8);
    carPath.close();
    canvas.drawPath(carPath, blackPaint);

    // 2) Draw the yellow circle (battery background)
    canvas.drawCircle(
      Offset(circleCenterX, circleCenterY),
      circleRadius,
      yellowPaint,
    );

    // 3) Draw a battery icon inside the circle
    //    We'll just draw a small rectangle with a + sign for demonstration
    final double batteryWidth = circleRadius * 0.8;
    final double batteryHeight = circleRadius * 0.5;
    final double batteryLeft = circleCenterX - batteryWidth / 2;
    final double batteryTop = circleCenterY - batteryHeight / 2;

    // Battery body
    final Rect batteryRect = Rect.fromLTWH(
      batteryLeft,
      batteryTop,
      batteryWidth,
      batteryHeight,
    );
    canvas.drawRect(batteryRect, blackPaint);

    // Battery "positive nub" on top
    final double nubWidth = batteryWidth * 0.15;
    final double nubHeight = batteryHeight * 0.1;
    final double nubLeft = circleCenterX - nubWidth / 2;
    final double nubTop = batteryTop - nubHeight;
    final Rect nubRect = Rect.fromLTWH(
      nubLeft,
      nubTop,
      nubWidth,
      nubHeight,
    );
    canvas.drawRect(nubRect, blackPaint);

    // 4) Draw a vertical line to the right of the circle
    final double lineX = circleCenterX + circleRadius + 10;
    final Paint linePaint = Paint()..color = yellowPaint.color;
    canvas.drawRect(
      Rect.fromLTWH(
        lineX, // left
        0, // top
        4, // thickness
        size.height * 0.8, // height
      ),
      linePaint,
    );

    // 5) Draw the text "AMPER For Car Batteries"
    //    Using a TextPainter for custom text drawing
    final textSpan = TextSpan(
      text: 'AMPER\n',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
          text: 'For Car Batteries',
          style: TextStyle(
            color: yellowPaint.color,
            fontSize: 14,
          ),
        ),
      ],
    );

    // Configure a TextPainter
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    // Position the text to the right of the line
    final double textLeft = lineX + 10;
    final double textTop = size.height * 0.3;
    textPainter.paint(canvas, Offset(textLeft, textTop));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
