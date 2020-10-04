import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class TwoDotsPainter extends CustomPainter {
  final double progress;
  final Color colorA;
  final Color colorB;

  int divisionsNumber;
  double divisionAngle;
  double arcAngle;
  double spaceAngle;

  double progressAngle;
  double lastProgressAngle = 0;

  bool isPairRound;

  TwoDotsPainter(
      {@required this.progress,
      @required this.isPairRound,
      @required this.colorA,
      @required this.colorB});

  @override
  void paint(Canvas canvas, Size size) {
    Paint circleApaint = Paint()
      ..color = colorA
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    Paint circleBpaint = Paint()
      ..color = colorB
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    double radius = size.height / 2;
    double sizeMultiplier = radius * 0.2;
    Offset center = Offset(size.width / 2, size.height / 2);
    progressAngle = 2 * pi * progress;

    canvas.translate(center.dx, center.dy);

    if (isPairRound) {
      canvas.drawCircle(
          Offset(sin(progressAngle) * (size.width - 2 * radius) / 2, 0),
          sin(progressAngle + pi / 2) * sizeMultiplier + radius,
          circleApaint);

      canvas.drawCircle(
          Offset(sin(progressAngle + pi) * (size.width - 2 * radius) / 2, 0),
          sin(progressAngle + pi / 2 + pi) * sizeMultiplier + radius,
          circleBpaint);
    } else {
      canvas.drawCircle(
          Offset(sin(progressAngle + pi) * (size.width - 2 * radius) / 2, 0),
          sin(progressAngle + pi / 2 + pi) * sizeMultiplier + radius,
          circleBpaint);
      canvas.drawCircle(
          Offset(sin(progressAngle) * (size.width - 2 * radius) / 2, 0),
          sin(progressAngle + pi / 2) * sizeMultiplier + radius,
          circleApaint);
    }

    lastProgressAngle = progressAngle;
  }

  Offset polarToCartesian(double angle, double r) {
    return Offset(r * cos(angle), r * sin(angle));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
