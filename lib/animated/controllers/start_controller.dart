import 'package:get/state_manager.dart';
import 'package:flutter/material.dart';

class StartController extends GetxController {
  AnimationController _animationController;
  Duration duration;
  Duration delay;
  bool repeatReverse;
  Function callback;

  StartController(
      {this.delay,
      this.repeatReverse = false,
      this.callback,
      @required this.duration});

  AnimationController get animationController => _animationController;
  set animationController(AnimationController value) =>
      _animationController = value;

  void disposeController() {
    animationController.dispose();
    animationController = null;
  }

  void startAnimation() {
    if (delay != null)
      Future.delayed(delay).then((value) => animationController?.forward());
    else
      animationController.forward();
  }

  void setAnimationListener() {
    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (repeatReverse) {
          animationController.reverse();
        } else {
          callback?.call();
        }
      } else if (status == AnimationStatus.dismissed) {
        callback?.call();
      }
    });
  }
}
