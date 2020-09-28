import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

import 'controllers/loop_controller.dart';

class AnimatedLoop extends StatefulWidget {
  Widget child;
  bool disableAnimation;
  Duration duration;
  bool repeatReverse;
  LoopController loopController;
  Function(AnimationController controller, Widget child) builder;

  AnimatedLoop(
      {Key key,
      @required this.builder,
      @required this.child,
      this.duration = const Duration(milliseconds: 1200),
      this.repeatReverse = false,
      this.disableAnimation = false,
      this.loopController})
      : super(key: key);

  @override
  _AnimatedLoopState createState() => _AnimatedLoopState();
}

class _AnimatedLoopState extends State<AnimatedLoop>
    with SingleTickerProviderStateMixin {
  LoopController loopController;

  @override
  void dispose() {
    loopController.disposeController();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedLoop oldWidget) {
    if (widget.loopController == null) {
      if (loopController.animationController.duration != widget.duration)
        loopController.animationController.duration = widget.duration;
      if (loopController.repeatReverse != widget.repeatReverse)
        loopController.repeatReverse = widget.repeatReverse;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.loopController != null)
      loopController = widget.loopController;
    else {
      String tag = math.Random().nextDouble().toString();
      loopController = Get.put(
          LoopController(
            duration: widget.duration,
            repeatReverse: widget.repeatReverse,
          ),
          tag: tag);
      loopController.animationController =
          AnimationController(vsync: this, duration: widget.duration);
      loopController.startAnimation();
      loopController.setAnimationListener();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disableAnimation)
      return widget.child;
    else
      return widget.builder(loopController.animationController, widget.child);
  }
}
