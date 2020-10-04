import 'package:flutter/material.dart';

import 'two_dots_painter.dart';

class TwoDotsIndicator extends StatefulWidget {
  Duration duration;
  final Color colorA;
  final Color colorB;

  TwoDotsIndicator({
    Key key,
    this.duration = const Duration(milliseconds: 2100),
    this.colorA = Colors.red,
    this.colorB = Colors.blue,
  }) : super(key: key);

  @override
  _TwoDotsIndicatorsState createState() => _TwoDotsIndicatorsState();
}

class _TwoDotsIndicatorsState extends State<TwoDotsIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  bool isPairRound = true;
  double lastValue = 0;

  double get delta => (controller.value - lastValue).abs();

  double acumulado = 0;

  void changeOverlap() {
    Future.delayed(Duration(
            milliseconds: (widget.duration.inMilliseconds / 4).floor()))
        .then((value) {
      setState(() {
        isPairRound = !isPairRound;
      });
    });
  }

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    controller.value = 0.5;
    controller.addListener(() {
      acumulado += delta;

      if (acumulado > 0.5) {
        changeOverlap();
        acumulado = 0;
      }

      lastValue = controller.value;
    });

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
            painter: TwoDotsPainter(
                isPairRound: isPairRound,
                progress: controller.value,
                colorA: widget.colorA,
                colorB: widget.colorB));
      },
    );
  }
}
