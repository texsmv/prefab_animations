import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

import 'controllers/tap_controller.dart';

class AnimatedTap extends StatefulWidget {
  Widget child;
  bool disableAnimation;
  Duration duration;
  Duration functionDelay;
  bool repeatReverse;
  Function onTap;
  bool absorbPointer;
  Function(AnimationController controller, Widget child) builder;
  TapController tapController;

  AnimatedTap(
      {Key key,
      @required this.builder,
      @required this.child,
      this.duration = const Duration(milliseconds: 1200),
      this.functionDelay,
      this.repeatReverse = false,
      this.disableAnimation = false,
      this.onTap,
      this.absorbPointer,
      this.tapController})
      : super(key: key);

  @override
  _AnimatedTapState createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap>
    with SingleTickerProviderStateMixin {
  TapController tapController;

  @override
  void dispose() {
    tapController.disposeController();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedTap oldWidget) {
    if (widget.tapController == null) {
      if (tapController.animationController.duration != widget.duration)
        tapController.animationController.duration = widget.duration;
      if (tapController.functionDelay != widget.functionDelay)
        tapController.functionDelay = widget.functionDelay;
      if (tapController.onTap != widget.onTap)
        tapController.onTap = widget.onTap;
      if (tapController.repeatReverse != widget.repeatReverse)
        tapController.repeatReverse = widget.repeatReverse;

      tapController.functionDelay =
          widget.functionDelay ?? _getDefaultFunctionDelay();
    }
    super.didUpdateWidget(oldWidget);
  }

  Duration _getDefaultFunctionDelay() {
    if (widget.repeatReverse == true)
      return widget.duration * 2;
    else
      return widget.duration;
  }

  @override
  void initState() {
    if (widget.tapController != null)
      tapController = widget.tapController;
    else {
      String tag = math.Random().nextDouble().toString();
      tapController = Get.put(
          TapController(
            duration: widget.duration,
            repeatReverse: widget.repeatReverse,
            onTap: widget.onTap,
            functionDelay: widget.functionDelay ?? _getDefaultFunctionDelay(),
          ),
          tag: tag);
      tapController.animationController =
          AnimationController(vsync: this, duration: widget.duration);
      tapController.setAnimationListener();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget tappableWidget = GestureDetector(
      child: AbsorbPointer(
        child: widget.child,
        absorbing: widget.absorbPointer ?? false,
      ),
      onTap: () {
        tapController.handleTap();
      },
    );

    if (widget.disableAnimation)
      return tappableWidget;
    else
      return widget.builder(tapController.animationController, tappableWidget);
  }
}
