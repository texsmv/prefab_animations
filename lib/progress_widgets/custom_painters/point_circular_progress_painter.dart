import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class PointCircularProgressPainter extends CustomPainter {
  final double width;
  final double percent;
  
  int _ballsNumber = 4;

  PointCircularProgressPainter({
                                this.width = 5, 
                                @required this.percent
                              });

  @override
  void paint(Canvas canvas, Size size) {
      Paint ballsPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

    

      Paint circlePaint = Paint()
        ..color = Color.fromARGB(255, 140, 140, 140)
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round 
        ..strokeWidth = width;
        


      Offset center = Offset(size.width/2, size.height/2);
      double loadingAngle = 2 * pi * percent;
      double sweepAngle = 2 * pi / _ballsNumber;
      double radius= min(size.width/2, size.height/2);

      canvas.drawCircle(center, radius, circlePaint);

      for (int i = 0; i < _ballsNumber; i++) {
        Offset relativePosition = polarToCartesian( loadingAngle + sweepAngle * i, radius / 2.4);
        canvas.drawCircle(center + relativePosition , radius / 9, ballsPaint);
      }


  }

  Offset polarToCartesian(double angle, double r){
    return Offset(r * cos(angle), r * sin(angle));
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
