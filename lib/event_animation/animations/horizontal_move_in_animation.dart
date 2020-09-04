import 'package:flutter/material.dart';

class HorizontalMoveInAnimation extends AnimatedWidget {
  Widget child;
  double movementSize;
  CurveTween tween;
  HorizontalMoveInAnimation({
    Key key,
    @required AnimationController controller,
    this.movementSize = 300,
    this.child,
    this.tween,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    if (tween == null) tween = CurveTween(curve: Curves.linear);
    return Transform.translate(
      offset:
          Offset(tween.evaluate(_progress) * movementSize - movementSize, 0),
      child: child,
    );
  }
}
