import 'package:flutter/material.dart';
import 'package:prefab_animations/event_animation/custom_curves/test_curve.dart';


class JumpAnimation extends AnimatedWidget {
  Widget child;
  double movementSize;
  JumpAnimation({
                  Key key, 
                  @required AnimationController controller, 
                  this.movementSize = 10,
                  this.child, 
                })
      : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;
  CurveTween tween = CurveTween(curve: GaussCurve());
  // Animatable<double> tween = CurveTween(curve: GaussCurve()).chain(CurveTween(curve: Curves.easeInOut));
  // CurveTween tween = CurveTween(curve: TestCurve(count: 1));

  @override
  Widget build(BuildContext context) {
    
    return Transform.translate(
      offset: Offset(0, tween.evaluate(_progress) * - movementSize),
      child: child,
    );
  }
}