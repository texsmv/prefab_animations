import 'package:flutter/material.dart';

class AppearAnimation extends AnimatedWidget {
  Widget child;
  AppearAnimation({
                    Key key, 
                    AnimationController controller, 
                    this.child, 
                 })
      : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _progress.value,
      child: child,
    );
  }
}