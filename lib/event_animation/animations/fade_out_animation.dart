import 'package:flutter/material.dart';

class FadeInAnimation extends AnimatedWidget {
  Widget child;
  FadeInAnimation({
                    Key key, 
                    AnimationController controller, 
                    this.child, 
                 })
      : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1 - _progress.value,
      child: child,
    );
  }
}