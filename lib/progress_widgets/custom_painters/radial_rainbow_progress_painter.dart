import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class RadialRainbowProgressPainter extends CustomPainter {
  final double width;
  final double percent;
  
  int _segmentsNumber = 5;

  RadialRainbowProgressPainter({
                  this.width = 5, 
                  @required this.percent
                });

  @override
  void paint(Canvas canvas, Size size) {
      Paint innerBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round 
        ..strokeWidth = width;

      Paint outterBorderPaint = Paint()
        ..color = Color.fromARGB(255, 140, 140, 140)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round 
        ..strokeWidth = width
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal, 4.0);

      List<Paint> paints = [
        Paint()
          ..color = Colors.red
          ..style= PaintingStyle.fill,
        
        Paint()
          ..color = Colors.blue
          ..style= PaintingStyle.fill,
          
        Paint()
          ..color = Colors.yellow
          ..style= PaintingStyle.fill,
        
        Paint()
          ..color = Colors.green
          ..style= PaintingStyle.fill,

        Paint()
          ..color = Colors.orange
          ..style= PaintingStyle.fill,

      ];

      Offset center = Offset(size.width/2, size.height/2);
      double loadingAngle = 2 * pi * percent;
      double sweepAngle = 2 * pi / _segmentsNumber;
      double radius= min(size.width/2, size.height/2);
      if(radius == 0) return;

      canvas.drawCircle(center, radius + width / 2, outterBorderPaint);
      canvas.drawCircle(center, radius, innerBorderPaint);

      for (int i = 0; i < _segmentsNumber; i++) {
        draw_circle_arc(
          paint: paints[i],
          canvas: canvas,
          center: center,
          startAngle: loadingAngle + sweepAngle * i,
          sweepAngle: sweepAngle,
          radius: radius,
        );
      }
      
  }

  Offset polar_to_cartesian(double angle, double r){
    return Offset(r * cos(angle), r * sin(angle));
  }

  void draw_circle_arc({
                        @required Canvas canvas, 
                        @required Offset center,
                        @required double startAngle,
                        @required double sweepAngle,
                        @required double radius, 
                        @required Paint paint,
                      }){
    Offset beginPosition = polar_to_cartesian(startAngle, radius);
    Offset endPosition = polar_to_cartesian(startAngle + sweepAngle, radius);

    // canvas.scale(0.4, 0.4);

    Path path = Path();

    path.moveTo(center.dx, center.dy);

    // path.lineTo(center.dx + endPosition.dx, center.dy + endPosition.dy);
    path.arcToPoint(Offset(center.dx + endPosition.dx, center.dy + endPosition.dy), radius: Radius.circular(radius), clockwise: false);

    path.arcToPoint(Offset(center.dx + beginPosition.dx, center.dy + beginPosition.dy ), radius: Radius.circular(radius), clockwise: false);
    
    // path.lineTo(center.dx, center.dy);
    path.arcToPoint(Offset(center.dx , center.dy), radius: Radius.circular(radius), clockwise: true);

    path.close();

    canvas.drawPath(path, paint); 
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
