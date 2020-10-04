import 'package:flutter/material.dart';
import 'package:prefab_animations/progress_widgets/divided_circle/divided_circle.dart';
import 'package:prefab_animations/progress_widgets/progress_indicators/point_circular_progress_indicator.dart';

import 'check_sign/check_sign.dart';

class ButtonContent extends StatelessWidget {
  final Widget child;
  bool loading;
  bool fadeContent;
  bool showCheck;
  Function callback;
  Duration checkAnimationDuration;
  Duration checkDelay;
  Duration indicatorAnimationDuration;
  double strokeWidth;
  Color color;
  ButtonContent(
      {Key key,
      @required this.child,
      @required this.loading,
      @required this.fadeContent,
      this.callback,
      @required this.indicatorAnimationDuration,
      @required this.checkAnimationDuration,
      @required this.checkDelay,
      @required this.color,
      @required this.strokeWidth,
      @required this.showCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox(
            height: 50,
            width: 50,
            child: Padding(
              child: showCheck
                  ? CheckSign(
                      callbackDelay: checkDelay,
                      animationDuration: checkAnimationDuration,
                      callback: callback,
                      color: color,
                      strokeWidth: strokeWidth,
                    )
                  : DividedCircleIndicator(
                      duration: indicatorAnimationDuration,
                      strokeWidth: strokeWidth,
                      spacePortion: 0.12,
                      strokeColor: color,
                    ),
              padding: EdgeInsets.all(8),
            ))
        : AnimatedOpacity(
            opacity: fadeContent ? 0 : 1,
            child: child,
            duration: Duration(milliseconds: 80),
          );
  }
}
