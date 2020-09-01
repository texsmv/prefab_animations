import 'package:flutter/material.dart';

class VerticalAppearAnimation extends AnimatedWidget {
  Widget child;
  double verticalOffSet;
  double minScale;
  CurveTween scaleTween;
  CurveTween opacityTween;
  CurveTween translateTween;
  VerticalAppearAnimation({
    Key key,
    @required AnimationController controller,
    this.verticalOffSet = 25,
    this.minScale = 0.8,
    this.scaleTween,
    this.opacityTween,
    this.translateTween,
    this.child,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    if (scaleTween == null) scaleTween = CurveTween(curve: Curves.linear);
    if (opacityTween == null) opacityTween = CurveTween(curve: Curves.linear);
    if (translateTween == null)
      translateTween = CurveTween(curve: Curves.linear);
    return Transform.scale(
      scale: 1 - ((1 - scaleTween.evaluate(_progress)) * (1 - minScale)),
      child: FadeTransition(
        opacity: opacityTween.animate(_progress),
        child: Transform.translate(
          offset: Offset(
              0,
              translateTween.evaluate(_progress) * verticalOffSet -
                  verticalOffSet),
          child: child,
        ),
      ),
    );
  }
}
