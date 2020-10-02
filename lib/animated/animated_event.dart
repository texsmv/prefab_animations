import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

import 'controllers/event_controller.dart';
import 'controllers/event_launcher.dart';

class AnimatedEvent extends StatefulWidget {
  Widget child;
  bool disableAnimation;
  Duration duration;
  bool repeatReverse;
  bool resetAfterForward;
  bool resetBeforeForward;
  EventLauncher eventHandler;

  Function(AnimationController controller, Widget child) builder;
  EventController eventController;

  AnimatedEvent(
      {Key key,
      @required this.builder,
      @required this.child,
      this.duration = const Duration(milliseconds: 1200),
      this.repeatReverse = true,
      this.disableAnimation = false,
      this.resetAfterForward = false,
      this.resetBeforeForward = true,
      this.eventHandler,
      this.eventController})
      : assert(eventController == null || eventHandler == null),
        super(key: key);

  @override
  _AnimatedEventState createState() => _AnimatedEventState();
}

class _AnimatedEventState extends State<AnimatedEvent>
    with SingleTickerProviderStateMixin {
  EventController eventController;

  @override
  void dispose() {
    eventController.disposeController();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedEvent oldWidget) {
    if (widget.eventController == null) {
      if (eventController.animationController.duration != widget.duration)
        eventController.animationController.duration = widget.duration;

      eventController.repeatReverse = widget.repeatReverse;
      eventController.resetAfterForward = widget.resetAfterForward;
      eventController.resetBeforeForward = widget.resetBeforeForward;

      if (oldWidget.eventHandler != widget.eventHandler) {
        eventController.eventHandler = widget.eventHandler;
        eventController.updateStreamSubscription();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.eventController != null)
      eventController = widget.eventController;
    else {
      String tag = math.Random().nextDouble().toString();
      eventController = Get.put(
          EventController(
              duration: widget.duration,
              repeatReverse: widget.repeatReverse,
              resetAfterForward: widget.resetAfterForward,
              resetBeforeForward: widget.resetBeforeForward,
              eventHandler: widget.eventHandler),
          tag: tag);
      eventController.animationController =
          AnimationController(vsync: this, duration: widget.duration);
      eventController.setAnimationListener();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disableAnimation)
      return widget.child;
    else
      return widget.builder(eventController.animationController, widget.child);
  }
}
