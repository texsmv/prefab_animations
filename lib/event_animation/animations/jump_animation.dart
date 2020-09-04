import 'package:flutter/material.dart';

class JumpAnimation extends AnimatedWidget {
  Widget child;
  double movementSize;
  CurveTween tween;
  JumpAnimation({
    Key key,
    @required AnimationController controller,
    this.movementSize = 10,
    this.child,
    this.tween,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    if (tween == null) tween = CurveTween(curve: Curves.ease);
    return Transform.translate(
      offset: Offset(0, tween.evaluate(_progress) * -movementSize),
      child: child,
    );
  }
}
