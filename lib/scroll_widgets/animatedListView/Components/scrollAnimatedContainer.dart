import 'package:flutter/material.dart';
import 'package:prefab_animations/scroll_widgets/animatedListView/Constants/scrollAnimations.dart';

import '../animatedListView.dart';

class ScrollAnimatedContainer extends StatefulWidget {
  bool animateOnTop;
  bool animateOnBottom;
  ValueNotifier<double> scrollOffsetNotifier;
  Widget child;
  double startPosition;
  ItemsData itemsData;
  int index;
  ScrollAnimations animationType;
  ScrollAnimatedContainer({
    Key key,
    @required this.child,
    @required this.scrollOffsetNotifier,
    @required this.index,
    @required this.startPosition,
    @required this.animationType,
    @required this.animateOnBottom,
    @required this.animateOnTop,
    @required this.itemsData,
  }) : super(key: key);

  @override
  Scroll_AnimatedContainerState createState() =>
      Scroll_AnimatedContainerState();
}

class Scroll_AnimatedContainerState extends State<ScrollAnimatedContainer>
    with SingleTickerProviderStateMixin {
  double scale = 1;
  AnimationController controller;
  Animatable<double> curveTween =
      Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.ease));
  Widget myChild;
  @override
  void initState() {
    myChild = widget.child;
    controller = AnimationController(vsync: this);
    super.initState();
  }

  double calculateControllerValue(
      double offset, double startPosition, double height, double layoutHeight) {
    if (offset > startPosition && widget.animateOnTop) {
      scale = (startPosition - (offset - height)) / height;
      if (scale > 1) scale = 1;
    } else if ((offset + layoutHeight - height) < startPosition &&
        widget.animateOnBottom) {
      scale = (startPosition - (offset + layoutHeight - height)) / height;
      if (scale > 1) scale = 1;
      scale = 1 - scale;
    } else {
      scale = 1;
    }
    return scale;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      child: widget.child,
      valueListenable: widget.scrollOffsetNotifier,
      builder: (context, value, child) {
        controller.value = calculateControllerValue(
            value,
            widget.itemsData.startPositions[widget.index],
            widget.itemsData.itemsHeight[widget.index],
            widget.itemsData.layoutHeight);
        return AnimatedBuilder(
          child: child,
          animation: controller,
          builder: (context, child) {
            switch (widget.animationType) {
              case ScrollAnimations.IN_BOTH_SIDES:
                double direction;
                if (widget.index % 2 == 0)
                  direction = 1;
                else
                  direction = -1;
                return FadeTransition(
                  opacity: curveTween.animate(controller),
                  child: Transform.translate(
                    offset: Offset(
                        direction *
                            MediaQuery.of(context).size.width *
                            (1 - curveTween.evaluate(controller)),
                        0),
                    child:
                        Align(alignment: Alignment.centerRight, child: child),
                  ),
                );
                break;
              case ScrollAnimations.RIGH_ROTATION:
                return FadeTransition(
                  opacity: curveTween.animate(controller),
                  child: Transform.rotate(
                    angle: -3.1415 / 2 * (1 - curveTween.evaluate(controller)),
                    alignment: Alignment.bottomRight,
                    child:
                        Align(alignment: Alignment.centerRight, child: child),
                  ),
                );
                break;
              case ScrollAnimations.CENTER_OUT:
                final double verticalOffSet = 25;
                final double minScale = 0.8;
                return Transform.scale(
                  scale: 1 -
                      ((1 - curveTween.evaluate(controller)) * (1 - minScale)),
                  child: FadeTransition(
                      opacity: curveTween.animate(controller), child: child),
                );

                break;
              case ScrollAnimations.ROTATE_X_AXIS:
                return FadeTransition(
                  opacity: curveTween.animate(controller),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.01)
                      ..rotateX(1 - curveTween.evaluate(controller)),
                    alignment: FractionalOffset.center,
                    child:
                        Align(alignment: Alignment.centerRight, child: child),
                  ),
                );
                break;
              case ScrollAnimations.IN_RIGHT:
                return FadeTransition(
                  opacity: curveTween.animate(controller),
                  child: Transform.translate(
                    offset: Offset(
                        widget.itemsData.itemsWidth[widget.index] *
                            (1 - curveTween.evaluate(controller)),
                        10 * (1 - curveTween.evaluate(controller))),
                    child:
                        Align(alignment: Alignment.centerRight, child: child),
                  ),
                );
                break;
            }
          },
        );
      },
    );
  }
}
