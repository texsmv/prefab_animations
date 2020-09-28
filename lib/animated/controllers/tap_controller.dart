import 'package:get/state_manager.dart';
import 'package:flutter/material.dart';

class TapController extends GetxController {
  AnimationController _animationController;
  Duration duration;
  bool repeatReverse;
  Duration functionDelay;
  Function onTap;

  bool tapTriggered = false;

  TapController(
      {this.repeatReverse = true,
      @required this.duration,
      this.onTap,
      this.functionDelay});

  AnimationController get animationController => _animationController;
  set animationController(AnimationController value) =>
      _animationController = value;

  void disposeController() {
    animationController.dispose();
    animationController = null;
  }

  void handleTap() {
    animationController.reset();
    animationController.stop();
    tapTriggered = true;
    animationController.forward();

    if (onTap != null) {
      if (functionDelay != null)
        Future.delayed(functionDelay).then((value) => onTap());
      else
        onTap();
    }
  }

  void setAnimationListener() {
    animationController.addStatusListener((status) {
      if (repeatReverse) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
          tapTriggered = false;
        } else if (status == AnimationStatus.dismissed && !tapTriggered) {
          animationController.reset();
        }
      } else {
        if (status == AnimationStatus.completed) {
          animationController.reset();
        }
      }
    });
  }
}
