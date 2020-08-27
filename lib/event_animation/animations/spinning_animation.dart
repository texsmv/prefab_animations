import 'package:flutter/material.dart';

class SpinningAnimation extends AnimatedWidget {
  Widget child;
  SpinningAnimation({
    Key key,
    AnimationController controller,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _progress,
      child: child,
    );
  }
}
