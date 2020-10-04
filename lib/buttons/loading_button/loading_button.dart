import 'package:flutter/material.dart';
import 'package:prefab_animations/animated/animated_event.dart';
import 'package:prefab_animations/animated/controllers/event_launcher.dart';
import 'package:prefab_animations/event_animation/event_animation.dart';

import 'components/buttonContent.dart';

class LoadingButton extends StatefulWidget {
  Widget child;
  double width;
  double height;
  Future<dynamic> Function() futureFunction;
  Duration checkAnimationDuration;
  Duration checkDelay;
  double strokeWidth;
  Color strokeColor;
  Duration indicatorDuration;
  Duration transformDuration;
  Function successCallback;
  Duration opacityDuration;

  Function(dynamic) hasSucceeded;

  Color fillColor;

  LoadingButton(
      {Key key,
      this.width,
      this.height,
      @required this.futureFunction,
      @required this.child,
      @required this.hasSucceeded,
      this.opacityDuration = const Duration(milliseconds: 80),
      this.successCallback,
      this.strokeWidth = 2,
      this.strokeColor = Colors.white,
      this.checkAnimationDuration = const Duration(milliseconds: 350),
      this.checkDelay = const Duration(milliseconds: 1350),
      this.indicatorDuration = const Duration(milliseconds: 1500),
      this.transformDuration = const Duration(milliseconds: 350),
      this.fillColor = Colors.red})
      : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  EventLauncher eventLauncher = EventLauncher();
  bool loading = false;
  bool fadeContent = false;
  bool showCheck = false;
  double loadingWidth;

  CurveTween transformTween = CurveTween(curve: Curves.easeOut);

  @override
  void initState() {
    loadingWidth = widget.height;
    super.initState();
  }

  @override
  void didUpdateWidget(LoadingButton oldWidget) {
    loadingWidth = widget.height;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedEvent(
      duration: widget.transformDuration,
      resetAfterForward: false,
      resetBeforeForward: false,
      repeatReverse: false,
      eventHandler: eventLauncher,
      child: ButtonContent(
        opacityDuration: widget.opacityDuration,
        indicatorAnimationDuration: widget.indicatorDuration,
        strokeWidth: widget.strokeWidth,
        color: widget.strokeColor,
        checkDelay: widget.checkDelay,
        checkAnimationDuration: widget.checkAnimationDuration,
        callback: () {
          showCheck = false;
          doBackward();
          if (widget.successCallback != null) widget.successCallback();
        },
        showCheck: showCheck,
        fadeContent: fadeContent,
        child: widget.child,
        loading: loading,
      ),
      builder: (controller, child) {
        return AnimatedBuilder(
          child: child,
          animation: controller,
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                eventLauncher.forward();
                setState(() {
                  fadeContent = true;
                });
                Future.delayed(widget.transformDuration).then((_) {
                  setState(() {
                    loading = true;
                  });
                  widget.futureFunction().then((value) {
                    onFutureFinish(value);
                  });
                });
              },
              child: Container(
                height: widget.height,
                width: widget.width -
                    (widget.width - loadingWidth) *
                        transformTween.evaluate(controller),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  color: widget.fillColor,
                ),
                child: Center(child: child),
              ),
            );
          },
        );
      },
    );
  }

  void onFutureFinish(dynamic result) {
    if (widget.hasSucceeded(result)) {
      this.setState(() {
        showCheck = true;
      });
    } else {
      doBackward();
    }
  }

  void doBackward() {
    this.setState(() {
      loading = false;
    });
    eventLauncher.backward();
    Future.delayed(widget.transformDuration).then((_) {
      setState(() {
        fadeContent = false;
      });
    });
  }
}
