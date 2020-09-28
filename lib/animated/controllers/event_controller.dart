import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prefab_animations/animated/controllers/event_launcher.dart';

class EventController extends GetxController {
  AnimationController _animationController;
  Duration duration;
  bool repeatReverse;
  bool resetAfterForward;
  bool resetBeforeForward;
  EventLauncher eventHandler;

  StreamSubscription streamSubscription;
  bool eventTriggered = false;

  EventController(
      {this.repeatReverse = true,
      @required this.duration,
      this.resetAfterForward = false,
      this.resetBeforeForward = true,
      @required this.eventHandler}) {
    streamSubscription = eventHandler.changeNotifier.stream.listen((event) {
      handleEvent(event);
    });
  }
  void handleEvent(int value) {
    if (value == 1 && resetBeforeForward) animationController.reset();
    eventTriggered = true;
    if (value == 1)
      animationController.forward();
    else if (value == -1) animationController.reverse();
  }

  AnimationController get animationController => _animationController;
  set animationController(AnimationController value) =>
      _animationController = value;

  void disposeController() {
    animationController.dispose();
    animationController = null;

    streamSubscription.cancel();
  }

  void setAnimationListener() {
    animationController.addStatusListener((status) {
      if (repeatReverse) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
          eventTriggered = false;
        } else if (status == AnimationStatus.dismissed && !eventTriggered) {
          if (resetAfterForward) animationController.reset();
        }
      } else {
        if (status == AnimationStatus.completed) {
          if (resetAfterForward) animationController.reset();
        }
      }
    });
  }

  void updateStreamSubscription() {
    streamSubscription.cancel();
    streamSubscription = null;
    if (!eventHandler.broadcast) {
      eventHandler.changeNotifier.close();
      eventHandler.changeNotifier = StreamController();
    }
    streamSubscription = eventHandler.changeNotifier.stream.listen((event) {
      handleEvent(event);
    });
  }
}
