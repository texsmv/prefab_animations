import 'package:flutter/material.dart';
import 'package:prefab_animations/event_animation/custom_curves/gauss_curve.dart';

class JumpAnimation extends AnimatedWidget {
  Widget child;
  double movementSize;
  JumpAnimation({
    Key key,
    @required AnimationController controller,
    this.movementSize = 10,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;
  CurveTween tween = CurveTween(curve: GaussCurve());

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, tween.evaluate(_progress) * -movementSize),
      child: child,
    );
  }
}
