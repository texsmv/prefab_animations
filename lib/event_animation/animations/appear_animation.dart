import 'package:flutter/material.dart';

class AppearAnimation extends AnimatedWidget {
  Widget child;
  CurveTween tween;
  AppearAnimation({
    Key key,
    AnimationController controller,
    this.child,
    this.tween,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    if (tween == null) tween = CurveTween(curve: Curves.linear);
    return FadeTransition(
      opacity: tween.animate(_progress),
      child: child,
    );
  }
}
