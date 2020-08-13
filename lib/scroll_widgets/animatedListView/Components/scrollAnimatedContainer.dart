import 'package:flutter/material.dart';
import 'package:prefab_animations/scroll_widgets/animatedListView/Constants/scrollAnimations.dart';


class ScrollAnimatedContainer extends StatefulWidget {
  double scrollOffSet;
  double layoutHeight;
  Widget child;
  double width;
  double height;
  int index;
  double startPosition;
  ScrollAnimations animationType;
  ScrollAnimatedContainer({
                            Key key,
                            @required this.child,
                            @required this.scrollOffSet,
                            @required this.width,
                            @required this.height,
                            @required this.layoutHeight,
                            @required this.index,
                            @required this.startPosition,
                            @required this.animationType,
                         }) : super(key: key);

  @override
  Scroll_AnimatedContainerState createState() => Scroll_AnimatedContainerState();
}

class Scroll_AnimatedContainerState extends State<ScrollAnimatedContainer> with SingleTickerProviderStateMixin{
  /// distance from top to this widget in the scroll
  // double startPosition;
  double scale = 1;
  AnimationController controller;
  Animatable<double> curveTween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.ease));


  @override
  void initState() {
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        bool isShown;
        isShown = ((widget.scrollOffSet + widget.layoutHeight - widget.height) > widget.startPosition);
        if(!isShown){
          scale = (widget.startPosition - (widget.scrollOffSet + widget.layoutHeight - widget.height)) / widget.height;
          if(scale > 1)
            scale = 1;
          scale = 1 - scale;
        }
        else{
          scale = 1;
        }
        controller.value = scale;

        if(widget.index == 3){
          // print("Offset: ${widget.scrollOffSet}");
          // print("Start position: ${widget.startPosition}");
          // print("Layour height: ${widget.layoutHeight}");
          // print("Scale: ${scale}");

        }


        switch(widget.animationType){
          case ScrollAnimations.IN_BOTH_SIDES : 
                double direction;
                if(widget.index % 2 == 0)
                  direction = 1;
                else
                  direction = -1;
                return Opacity(
                  opacity: curveTween.evaluate(controller),
                  child: Transform.translate(
                  offset: Offset(direction * MediaQuery.of(context).size.width * (1 - curveTween.evaluate(controller)), 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: widget.child
                    ),
                  ),
                );
                break;
          case ScrollAnimations.RIGH_ROTATION :
                return Opacity(
                  opacity: curveTween.evaluate(controller),
                  child: Transform.rotate(
                    angle: -3.1415 / 2 *  (1 - curveTween.evaluate(controller)),
                    alignment: Alignment.bottomRight,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: widget.child
                    ),
                  ),
                );
                break;
          case ScrollAnimations.CENTER_OUT :
                return Opacity(
                  opacity: curveTween.evaluate(controller),
                  child: Transform(
                    transform: Matrix4.identity()..scale(curveTween.evaluate(controller),curveTween.evaluate(controller)),
                    alignment: Alignment.bottomCenter,
                    child: Align(
                      alignment: Alignment.center,
                      child: widget.child
                    ),
                  ),
                );
                break;
          case ScrollAnimations.ROTATE_X_AXIS :
                return Opacity(
                  opacity: curveTween.evaluate(controller),
                  child: Transform(
                  transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.01)
                      ..rotateX(1 - curveTween.evaluate(controller)),
                    alignment: FractionalOffset.center,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: widget.child
                    ),
                  ),
                );
                break;
          case ScrollAnimations.IN_RIGHT :
                return Opacity(
                  opacity: curveTween.evaluate(controller),
                  child: Transform.translate(
                  offset: Offset(widget.width * (1 - curveTween.evaluate(controller)), 10 * (1 - curveTween.evaluate(controller))),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: widget.child
                    ),
                  ),
                );
                break;
        }
        
      }
    );
    
  }
}