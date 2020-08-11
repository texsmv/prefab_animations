import 'package:flutter/material.dart';
import 'package:prefab_animations/event_animation/custom_curves/test_curve.dart';

class BounceAnimation extends AnimatedWidget {
  Widget child;
  double minScale;
  BounceAnimation({
                    Key key, 
                    AnimationController controller, 
                    this.child, 
                    this.minScale = 0.9,
                 })
      : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;
  CurveTween tween = CurveTween(curve: GaussCurve());

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - (tween.evaluate(_progress) * (1 - minScale)) ,
      child: child,
    );
  }
}