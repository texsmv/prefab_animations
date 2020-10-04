import 'package:flutter/material.dart';
import 'dart:math';

class CheckSignPainter extends CustomPainter {
  final double progress;
  final Color strokeColor;
  final double strokeWidth;

  CheckSignPainter(
      {@required this.progress,
      this.strokeColor = Colors.white,
      this.strokeWidth = 1});

  double sideSize;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    sideSize = min(size.width, size.height);
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    Path path = Path();

    path.moveTo((-0.4) * sideSize, 0.1 * sideSize);
    // path.lineTo((-0.23) * sideSize, (0.3) * sideSize);
    path.arcToPoint(Offset((-0.23) * sideSize, (0.3) * sideSize),
        radius: Radius.circular(sideSize));
    // path.lineTo((1 / 3) * sideSize, (-1 / 3) * sideSize);
    path.arcToPoint(Offset((1 / 3) * sideSize, (-1 / 3) * sideSize),
        radius: Radius.circular(sideSize * 1.6));

    double totalLength =
        path.computeMetrics().fold(0.0, (prev, metric) => prev + metric.length);

    double currentLength = progress * totalLength;

    canvas.drawPath(extractPathUntilLength(path, currentLength), paint);
    canvas.restore();
  }

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = new Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
