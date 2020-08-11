import 'dart:core';
import 'dart:math' as math;

import 'package:flutter/material.dart';


class EllipseAnimation extends AnimatedWidget {
  Widget child;
  /// width of the ellipse
  double a = -1;
  /// height of the ellipse
  double b = 0.7;

  bool clockwise;
  double scale;
  double _r;
  double _angle;
  bool _isForward;
  double _value;

  EllipseAnimation({
                    Key key, 
                    @required AnimationController controller, 
                    this.a = -1,
                    this.b = 0.7,
                    this.scale = 3,
                    this.clockwise = true,
                    this.child, 
                  })
      : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(BuildContext context) {
    if(clockwise)
      _value = 1 - _progress.value;
    else
      _value = _progress.value;
    return Transform.translate(
      offset: Offset(getX(_value) * scale,  getY(_value) * scale - ((b * scale))),
      child: child,
    );
  }

  double getR(double angle){
    _r =  (a * b) / math.sqrt(math.pow(b * math.cos(angle), 2) + math.pow(a * math.sin(angle), 2));
    return _r;
  }

  double getX(double val){
    _angle = (val * math.pi * 2) - (math.pi * 1 / 2);
    double r = getR(_angle);
    return r  * math.cos(_angle);
  }

  double getY(double val){
    _angle = (val * math.pi * 2) - (math.pi * 1 / 2);
    double r = getR(_angle);
    return (r  * math.sin(_angle));
  }
}