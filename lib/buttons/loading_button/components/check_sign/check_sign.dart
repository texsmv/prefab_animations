import 'package:flutter/material.dart';

import 'check_sign_painter.dart';

class CheckSign extends StatefulWidget {
  Duration animationDuration;
  Duration callbackDelay;
  double strokeWidth;
  Color color;
  Function callback;

  CheckSign(
      {Key key,
      this.animationDuration = const Duration(milliseconds: 350),
      this.callbackDelay = const Duration(milliseconds: 1550),
      this.color = Colors.white,
      this.callback,
      this.strokeWidth = 2})
      : super(key: key);

  @override
  _CheckSignState createState() => _CheckSignState();
}

class _CheckSignState extends State<CheckSign>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: widget.animationDuration);
    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(widget.callbackDelay).then((value) {
          widget?.callback();
        });
      }
    });
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
          painter: CheckSignPainter(
            progress: controller.value,
            strokeColor: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}
