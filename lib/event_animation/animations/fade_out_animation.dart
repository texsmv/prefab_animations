import 'package:flutter/material.dart';

class FadeOutAnimation extends AnimatedWidget {
  Widget child;
  CurveTween tween;
  FadeOutAnimation({
    Key key,
    AnimationController controller,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;
  Animatable<double> flippedTween = CurveTween(curve: Curves.linear.flipped);

  @override
  Widget build(BuildContext context) {
    if (tween == null) tween = CurveTween(curve: Curves.linear);
    if (flippedTween == null)
      flippedTween = CurveTween(curve: tween.curve.flipped);
    return FadeTransition(
      opacity: flippedTween.animate(_progress),
      child: child,
    );
  }
}
