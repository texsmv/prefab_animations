import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'animated_event.dart';
import 'animated_loop.dart';
import 'animated_start.dart';
import 'animated_tap.dart';
import 'controllers/event_controller.dart';
import 'controllers/event_launcher.dart';
import 'controllers/loop_controller.dart';
import 'controllers/start_controller.dart';
import 'controllers/tap_controller.dart';

class Animated extends StatefulWidget {
  Widget child;
  Duration startDuration;
  Duration startDelay;
  bool startRepeatReverse;
  Function startCallback;
  bool startDisableAnimation;
  bool loopDisableAnimation;
  Duration loopDuration;
  bool loopRepeatReverse;
  bool tapDisableAnimation;
  Duration tapDuration;
  Duration tapFunctionDelay;
  bool tapRepeatReverse;
  bool tapAbsorbPointer;
  Function onTap;
  Duration eventDuration;
  bool eventRepeatReverse;
  bool eventResetAfterForward;
  bool eventResetBeforeForward;
  EventLauncher eventHandler;

  Function(AnimationController controller, Widget child) startBuilder;
  Function(AnimationController controller, Widget child) loopBuilder;
  Function(AnimationController controller, Widget child) eventBuilder;
  Function(AnimationController controller, Widget child) tapBuilder;

  Animated(
      {Key key,
      @required this.child,
      this.startDuration = const Duration(milliseconds: 250),
      this.startDelay,
      this.startRepeatReverse = false,
      this.startCallback,
      this.startDisableAnimation,
      this.startBuilder,
      this.loopDuration = const Duration(milliseconds: 150),
      this.loopDisableAnimation = false,
      this.loopRepeatReverse = true,
      this.loopBuilder,
      this.tapDisableAnimation = false,
      this.tapDuration = const Duration(milliseconds: 250),
      this.tapFunctionDelay,
      this.tapRepeatReverse = true,
      this.onTap,
      this.tapAbsorbPointer = false,
      this.tapBuilder,
      this.eventDuration = const Duration(milliseconds: 250),
      this.eventRepeatReverse = true,
      this.eventResetAfterForward = false,
      this.eventResetBeforeForward = true,
      this.eventHandler,
      this.eventBuilder})
      : super(key: key);

  @override
  _AnimatedState createState() => _AnimatedState();
}

class _AnimatedState extends State<Animated> with TickerProviderStateMixin {
  StartController startController;
  LoopController loopController;
  TapController tapController;
  EventController eventController;

  bool doStart;
  bool doLoop;
  bool doEvent;
  bool doTap;

  void _putControllers() {
    if (doStart) {
      String tag = math.Random().nextDouble().toString();

      // Add loop animation start on AnimatedInit callback
      var callback = widget.startCallback;
      if (doLoop) {
        if (callback == null)
          callback = () {
            loopController.startAnimation();
            loopController.setAnimationListener();
          };
        else
          callback = () {
            loopController.startAnimation();
            loopController.setAnimationListener();
            widget.startCallback();
          };
      }

      startController = Get.put(
          StartController(
              callback: callback,
              delay: widget.startDelay,
              duration: widget.startDuration,
              repeatReverse: widget.startRepeatReverse),
          tag: tag);
    }

    if (doLoop) {
      String tag = math.Random().nextDouble().toString();
      loopController = Get.put(
          LoopController(
              duration: widget.loopDuration,
              repeatReverse: widget.loopRepeatReverse),
          tag: tag);
    }

    if (doTap) {
      String tag = math.Random().nextDouble().toString();
      tapController = Get.put(
          TapController(
              duration: widget.tapDuration,
              repeatReverse: widget.tapRepeatReverse,
              onTap: widget.onTap,
              functionDelay:
                  widget.tapFunctionDelay ?? _getDefaultFunctionDelay()),
          tag: tag);
    }

    if (doEvent) {
      String tag = math.Random().nextDouble().toString();
      eventController = Get.put(
          EventController(
              duration: widget.eventDuration,
              repeatReverse: widget.eventRepeatReverse,
              resetAfterForward: widget.eventResetAfterForward,
              resetBeforeForward: widget.eventResetBeforeForward,
              eventHandler: widget.eventHandler),
          tag: tag);
    }
  }

  Duration _getDefaultFunctionDelay() {
    if (widget.tapRepeatReverse == true)
      return widget.tapDuration * 2;
    else
      return widget.tapDuration;
  }

  @override
  void didUpdateWidget(Animated oldWidget) {
    if (doLoop) {
      loopController.animationController.duration = widget.loopDuration;
      if (loopController.repeatReverse != widget.loopRepeatReverse)
        loopController.repeatReverse = widget.loopRepeatReverse;
    }
    if (doStart)
      startController.animationController.duration = widget.startDuration;
    if (doTap) {
      if (tapController.animationController.duration != widget.tapDuration)
        tapController.animationController.duration = widget.tapDuration;
      tapController.functionDelay =
          widget.tapFunctionDelay ?? _getDefaultFunctionDelay();
      if (tapController.onTap != widget.onTap)
        tapController.onTap = widget.onTap;
      if (tapController.repeatReverse != widget.tapRepeatReverse)
        tapController.repeatReverse = widget.tapRepeatReverse;
    }
    if (doEvent) {
      eventController.animationController.duration = widget.eventDuration;
      eventController.repeatReverse = widget.eventRepeatReverse;
      eventController.resetAfterForward = widget.eventResetAfterForward;
      eventController.resetBeforeForward = widget.eventResetBeforeForward;
      if (oldWidget.eventHandler != widget.eventHandler) {
        eventController.eventHandler = widget.eventHandler;
        eventController.updateStreamSubscription();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    doStart = (widget.startBuilder != null);
    doLoop = (widget.loopBuilder != null);
    doTap = (widget.tapBuilder != null);
    doEvent = (widget.eventBuilder != null);

    _putControllers();

    if (doStart) {
      startController.animationController =
          AnimationController(vsync: this, duration: widget.startDuration);
      startController.startAnimation();
      startController.setAnimationListener();
    }

    if (doLoop) {
      loopController.animationController =
          AnimationController(vsync: this, duration: widget.loopDuration);

      // start loop animation if there is not start animation
      if (!doStart) {
        loopController.startAnimation();
        loopController.setAnimationListener();
      }
    }

    if (doTap) {
      tapController.animationController =
          AnimationController(vsync: this, duration: widget.tapDuration);
      tapController.setAnimationListener();
    }

    if (doEvent) {
      eventController.animationController =
          AnimationController(vsync: this, duration: widget.eventDuration);
      eventController.setAnimationListener();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedChild = widget.child;

    if (doStart)
      animatedChild = AnimatedStart(
        child: animatedChild,
        builder: widget.startBuilder,
        startController: startController,
      );

    if (doLoop)
      animatedChild = AnimatedLoop(
        child: animatedChild,
        builder: widget.loopBuilder,
        loopController: loopController,
      );

    if (doTap)
      animatedChild = AnimatedTap(
        child: animatedChild,
        builder: widget.tapBuilder,
        tapController: tapController,
        absorbPointer: widget.tapAbsorbPointer,
      );

    if (doEvent) {
      animatedChild = AnimatedEvent(
        child: animatedChild,
        builder: widget.eventBuilder,
        eventController: eventController,
      );
    }

    return animatedChild;
  }
}
