import 'package:flutter/material.dart';

class FadeOutAnimation extends AnimatedWidget {
  Widget child;
  FadeOutAnimation({
    Key key,
    AnimationController controller,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;
  Animatable<double> tween = CurveTween(curve: Curves.linear.flipped);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: tween.animate(_progress),
      child: child,
    );
  }
}
