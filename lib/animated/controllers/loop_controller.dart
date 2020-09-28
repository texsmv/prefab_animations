import 'package:get/state_manager.dart';
import 'package:flutter/material.dart';

class LoopController extends GetxController {
  AnimationController _animationController;
  Duration duration;
  bool repeatReverse;

  LoopController({this.repeatReverse = true, @required this.duration});

  AnimationController get animationController => _animationController;
  set animationController(AnimationController value) =>
      _animationController = value;

  void disposeController() {
    animationController.dispose();
    animationController = null;
  }

  void startAnimation() {
    animationController.forward();
  }

  void setAnimationListener() {
    animationController.addStatusListener((status) {
      if (repeatReverse) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      } else {
        if (status == AnimationStatus.completed) {
          animationController.reset();
          animationController.forward();
        }
      }
    });
  }
}
