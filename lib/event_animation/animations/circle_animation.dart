import 'dart:core';
import 'dart:math' as math;

import 'package:flutter/material.dart';


class CircleAnimation extends AnimatedWidget {
  Widget child;
  /// circle radius
  double r;
  double x;
  double y;
  bool clockwise;
  bool _isForward;
  double _angle;
  double _value;

  CircleAnimation({
                    Key key, 
                    @required AnimationController controller, 
                    this.r = 50,
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
      offset: Offset(getX(_value) , getY(_value) - r),
      child: child,
    );
  }

  double getX(double val){
    _angle = (val * math.pi * 2) + (math.pi * 1 / 2);
    return r * math.cos(_angle);
  }

  double getY(double val){
    _angle = (val * math.pi * 2) + (math.pi * 1 / 2);
    return r * math.sin(_angle);
  }
}