import 'package:flutter/material.dart';

class BounceAnimation extends AnimatedWidget {
  Widget child;
  double minScale;
  CurveTween tween;
  BounceAnimation({
    Key key,
    AnimationController controller,
    this.child,
    this.minScale = 0.9,
    this.tween,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    if (tween == null) tween = CurveTween(curve: Curves.linear);
    return Transform.scale(
      scale: 1 - (tween.evaluate(_progress) * (1 - minScale)),
      child: child,
    );
  }
}
