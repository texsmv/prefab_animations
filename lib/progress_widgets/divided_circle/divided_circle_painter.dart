import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class DividedCirclePainter extends CustomPainter {
  final double width;
  final double progress;
  final int arcNumber;
  final Color strokeColor;
  final double spacePortion;

  int divisionsNumber;
  double divisionAngle;
  double arcAngle;
  double spaceAngle;

  double progressAngle;

  DividedCirclePainter(
      {this.width = 5,
      @required this.progress,
      this.arcNumber = 3,
      this.spacePortion = 0.1,
      this.strokeColor = Colors.grey})
      : assert(spacePortion < 1 && spacePortion > 0),
        assert(arcNumber > 0),
        assert(spacePortion < 1 / arcNumber);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width;

    double radius = min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);

    Rect circleRect =
        Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius);

    progressAngle = 2 * pi * progress;

    divisionAngle = 2 * pi / arcNumber;

    spaceAngle = 2 * pi * spacePortion;

    arcAngle = divisionAngle - spaceAngle;

    Path path = Path();

    for (int i = 0; i < arcNumber; i++) {
      path.addArc(circleRect, progressAngle + divisionAngle * i, arcAngle);
      // canvas.drawArc(circleRect, progressAngle + divisionAngle * i, arcAngle,
      //     true, circlePaint);
    }

    canvas.drawPath(path, circlePaint);
  }

  Offset polarToCartesian(double angle, double r) {
    return Offset(r * cos(angle), r * sin(angle));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
