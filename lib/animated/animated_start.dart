import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'controllers/start_controller.dart';

class AnimatedStart extends StatefulWidget {
  Widget child;
  bool disableAnimation;
  Duration duration;
  Duration delay;
  bool repeatReverse;
  Function callback;
  StartController startController;
  Function(AnimationController controller, Widget child) builder;

  AnimatedStart({
    Key key,
    @required this.builder,
    @required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.delay,
    this.disableAnimation = false,
    this.repeatReverse = false,
    this.callback,
    this.startController,
  }) : super(key: key);

  @override
  _AnimatedStartState createState() => _AnimatedStartState();
}

class _AnimatedStartState extends State<AnimatedStart>
    with SingleTickerProviderStateMixin {
  StartController startController;

  @override
  void dispose() {
    startController.disposeController();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedStart oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.startController != null)
      startController = widget.startController;
    else {
      String tag = math.Random().nextDouble().toString();
      startController = Get.put(
          StartController(
              delay: widget.delay,
              duration: widget.duration,
              repeatReverse: widget.repeatReverse,
              callback: widget.callback),
          tag: tag);
      startController.animationController =
          AnimationController(vsync: this, duration: widget.duration);
      startController.startAnimation();
      startController.setAnimationListener();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disableAnimation)
      return widget.child;
    else
      return widget.builder(startController.animationController, widget.child);
  }
}
