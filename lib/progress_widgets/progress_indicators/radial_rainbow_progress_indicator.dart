import 'package:flutter/material.dart';
import 'package:prefab_animations/progress_widgets/custom_painters/radial_rainbow_progress_painter.dart';


class RadialRainbowProgressIndicator extends StatefulWidget {
  Duration duration;
  RadialRainbowProgressIndicator({
                                  Key key,
                                  this.duration = const Duration(milliseconds: 1400),
                                }) : super(key: key);

  @override
  _RadialRainbowProgressIndicatorsState createState() => _RadialRainbowProgressIndicatorsState();
}

class _RadialRainbowProgressIndicatorsState extends State<RadialRainbowProgressIndicator> with SingleTickerProviderStateMixin{
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
          painter: RadialRainbowProgressPainter(
            percent: controller.value ,
            width: 5.0
          )
        );
      },
    );
    
  }
}