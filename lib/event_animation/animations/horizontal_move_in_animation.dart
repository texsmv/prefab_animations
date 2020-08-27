import 'package:flutter/material.dart';

class HorizontalMoveInAnimation extends AnimatedWidget {
  Widget child;
  double movementSize;
  HorizontalMoveInAnimation({
    Key key,
    @required AnimationController controller,
    this.movementSize = 300,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_progress.value * movementSize - movementSize, 0),
      child: child,
    );
  }
}
