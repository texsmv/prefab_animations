import 'package:flutter/material.dart';

class VerticalAppearAnimation extends AnimatedWidget {
  Widget child;
  double verticalOffSet;
  double minScale;
  VerticalAppearAnimation({
    Key key,
    @required AnimationController controller,
    this.verticalOffSet = 25,
    this.minScale = 0.8,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - ((1 - _progress.value) * (1 - minScale)),
      child: FadeTransition(
        opacity: _progress,
        child: Transform.translate(
          offset: Offset(0, _progress.value * verticalOffSet - verticalOffSet),
          child: child,
        ),
      ),
    );
  }
}
