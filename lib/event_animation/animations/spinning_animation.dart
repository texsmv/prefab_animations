import 'package:flutter/material.dart';

class SpinningAnimation extends AnimatedWidget {
  Widget child;
  CurveTween tween;
  SpinningAnimation({
    Key key,
    AnimationController controller,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    if (tween == null) tween = CurveTween(curve: Curves.linear);
    return RotationTransition(
      turns: _progress,
      child: child,
    );
  }
}
