import 'dart:math' as math;

import 'package:flutter/material.dart';

class TestCurve extends Curve {
  final double count;

  TestCurve({this.count = 3});

  @override
  double transformInternal(double t) {
    double val = math.sin(count * 2 * math.pi * (t + 0.23)) * 0.5 + 0.5;
    return 1 - val;
  }
}

class SineOutCurve extends Curve {
  /// Creates an sine-out curve.
  ///
  /// Rather than creating a new instance, consider using [Ease.sineOut].
  const SineOutCurve();

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    final double haftPi = math.pi / 2;
    final double result = math.sin(t * haftPi);
    return result;
  }

  @override
  String toString() {
    return '$runtimeType()';
  }
}

/// An oscillating curve that shrinks in magnitude while overshooting its bounds.
///
/// An instance of this class using the default period of 0.4 is available as
/// [Ease.sineIn].
///
class SineInCurve extends Curve {
  /// Creates an sine-in curve.
  ///
  /// Rather than creating a new instance, consider using [Ease.sineIn].
  const SineInCurve();

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    final double haftPi = math.pi / 2;
    final double result = -math.cos(t * haftPi) + 1;
    return result;
  }

  @override
  String toString() {
    return '$runtimeType()';
  }
}

class SineInOutCurve extends Curve {
  /// Creates an sine-in-out curve.
  ///
  /// Rather than creating a new instance, consider using [Ease.sineInOut].
  const SineInOutCurve();

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    final double result = -0.5 * (math.cos(math.pi * t) - 1);
    return result;
  }

  @override
  String toString() {
    return '$runtimeType()';
  }
}

class GaussCurve extends Curve {
  /// Creates an sine-in-out curve.
  ///
  /// Rather than creating a new instance, consider using [Ease.sineInOut].

  double a = 1;
  double b = 0.5;
  double c = -0.18;
  GaussCurve();

  @override
  double transform(double t) {
    return a * math.exp(-(math.pow(t - b, 2)) / (2 * (math.pow(c, 2))));
  }
}
