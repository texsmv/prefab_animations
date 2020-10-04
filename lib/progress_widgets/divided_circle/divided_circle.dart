import 'package:flutter/material.dart';
import 'package:prefab_animations/progress_widgets/custom_painters/point_circular_progress_painter.dart';

import 'divided_circle_painter.dart';

class DividedCircleIndicator extends StatefulWidget {
  /// Duration of one spin
  Duration duration;

  /// Number of arcs to be drawn
  final int arcNumber;

  /// Color use to paint the arcs
  final Color strokeColor;

  /// Portion of the arc that will be missing
  ///
  /// this value must be less than 1 / [arcNumber]
  final double spacePortion;

  final double strokeWidth;

  DividedCircleIndicator({
    Key key,
    this.arcNumber = 3,
    this.strokeColor = Colors.grey,
    this.spacePortion = 0.05,
    this.duration = const Duration(milliseconds: 1100),
    this.strokeWidth = 4,
  }) : super(key: key);

  @override
  _DividedCircleIndicatorsState createState() =>
      _DividedCircleIndicatorsState();
}

class _DividedCircleIndicatorsState extends State<DividedCircleIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
            painter: DividedCirclePainter(
                progress: controller.value,
                arcNumber: widget.arcNumber,
                spacePortion: widget.spacePortion,
                width: widget.strokeWidth,
                strokeColor: widget.strokeColor));
      },
    );
  }
}
