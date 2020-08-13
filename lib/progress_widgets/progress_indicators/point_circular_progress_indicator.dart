import 'package:flutter/material.dart';
import 'package:prefab_animations/progress_widgets/custom_painters/point_circular_progress_painter.dart';


class PointCircularProgressIndicator extends StatefulWidget {
  Duration duration;
  PointCircularProgressIndicator({
                                  Key key,
                                  this.duration = const Duration(milliseconds: 900),
                                }) : super(key: key);

  @override
  _PointCircularProgressIndicatorsState createState() => _PointCircularProgressIndicatorsState();
}

class _PointCircularProgressIndicatorsState extends State<PointCircularProgressIndicator> with SingleTickerProviderStateMixin{
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
          painter: PointCircularProgressPainter(
            percent: controller.value ,
            width: 5.0
          )
        );
      },
    );
    
  }
}