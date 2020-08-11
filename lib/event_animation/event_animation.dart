library prefab_animations;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prefab_animations/event_animation/constants/event_animation_states.dart';

class EventAnimation extends StatefulWidget {
  Widget child;
  Function(AnimationController controller, Widget child) initAnimationBuilder;
  Function(AnimationController controller, Widget child) awaitAnimationBuilder;
  Function(AnimationController controller, Widget child) onTapAnimationBuilder;
  Function(AnimationController controller, Widget child) onEventAnimationBuilder;
  Duration initAnimationDuration;
  Duration awaitAnimationDuration;
  Duration onTapAnimationDuration;
  Duration onEventAnimationDuration;
  Function onTap;
  Stream eventStreamTrigger;

  EventAnimation({
                  Key key,
                  @required this.child,
                  this.initAnimationDuration = const Duration(milliseconds: 450),
                  this.awaitAnimationDuration = const Duration(milliseconds: 900),
                  this.onTapAnimationDuration = const Duration(milliseconds: 250),
                  this.onEventAnimationDuration = const Duration(milliseconds: 250),
                  this.initAnimationBuilder,
                  this.awaitAnimationBuilder,
                  this.onTapAnimationBuilder,
                  this.onEventAnimationBuilder,
                  this.onTap = null,
                  this.eventStreamTrigger = null,
                }) : super(key: key);

  @override
  _EventAnimationState createState() => _EventAnimationState();
}

class _EventAnimationState extends State<EventAnimation> with TickerProviderStateMixin{
  EventAnimationState state;
  EventAnimationState lastState;
  AnimationController initController;
  AnimationController awaitController;
  AnimationController onTapController;
  AnimationController onEventController;

  bool animateOnInit;
  bool animateOntap;
  bool animateOnAwait;
  bool animateOnEvent;

  StreamSubscription streamSubscription;

  @override
  void initState() {
    animateOnInit = !(widget.initAnimationBuilder == null);
    animateOntap = !(widget.onTapAnimationBuilder == null);
    animateOnAwait = !(widget.awaitAnimationBuilder == null);
    animateOnEvent = (!(widget.eventStreamTrigger == null) && !(widget.onEventAnimationBuilder == null));

    if(animateOnInit){
      state = EventAnimationState.INIT;
      initController = AnimationController(vsync: this, duration: widget.initAnimationDuration);
      initController.forward();

      if(animateOnAwait){
        initController.addStatusListener((AnimationStatus status) {
          if(status == AnimationStatus.completed){
            state = EventAnimationState.AWAITING;
            awaitController.forward();
          }
        });
      }
    }
    else{
      state = EventAnimationState.AWAITING;
    }

    if(animateOnAwait){
      awaitController = AnimationController(vsync: this, duration: widget.awaitAnimationDuration);

      awaitController.addListener(() {
        setState(() {
          
        });
      });

      awaitController.addStatusListener((AnimationStatus status) {
        if(status == AnimationStatus.completed){
          awaitController.reset();
          awaitController.forward();
        }
      });
      
      if(!animateOnInit){
        state = EventAnimationState.AWAITING;
        awaitController.forward();
      }
    }

    if(animateOntap){
      onTapController = AnimationController(vsync: this, duration: widget.onTapAnimationDuration);
      onTapController.addStatusListener((status) {
        if(status == AnimationStatus.completed){
          setState(() {
            state = EventAnimationState.AWAITING;
            onTapController.reset();
          });
        }
      });

      onTapController.addListener(() {
        setState(() {
          
        });
      });
    }

    if(animateOnEvent){

      onEventController = AnimationController(vsync: this, duration: widget.onEventAnimationDuration);
      onEventController.addStatusListener((status) {
        if(status == AnimationStatus.completed){
          setState(() {
            state = lastState;
            onEventController.reset();
          });
        }
      });

      onEventController.addListener(() {
        setState(() {
          
        });
      });

      streamSubscription = widget.eventStreamTrigger.listen((event) {onEvent();});
    }

    super.initState();
  }

  @override
  void didUpdateWidget(EventAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(animateOnEvent){
      if (widget.eventStreamTrigger != oldWidget.eventStreamTrigger) {
        streamSubscription.cancel();
        streamSubscription = widget.eventStreamTrigger.listen((_) {onEvent();});
      }
    }
  }

  @override
  void dispose() {
    if(streamSubscription != null)
      streamSubscription.cancel();

    if(onEventController != null)
      onEventController.dispose();
    if(awaitController != null)
      awaitController.dispose();
    if(initController != null)
      initController.dispose();
    if(onTapController != null)
      onTapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// tapable widget
    Widget childWidget = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onTap: (){
        onTap();
      },
    );



    /// onInit state
    /// 
    /// No other animations can be played
    if(state == EventAnimationState.INIT && animateOnInit){
      return AnimatedBuilder(
        animation: initController,
        builder: (context, child) {
          return widget.initAnimationBuilder(initController, child);
        },
        child: childWidget,
      );
    }




    /// on tap, awaiting or customEvent state
    /// 
    /// Animations can be mixed
    else if(state == EventAnimationState.AWAITING || state == EventAnimationState.ON_TAP || state == EventAnimationState.ON_EVENT){

      /// only [awaitAnimationBuilder]
      if(!animateOntap && !animateOnEvent){
        return AnimatedBuilder(
          animation: awaitController,
          builder: (context, child) {
            return widget.awaitAnimationBuilder(
              awaitController, 
              child,
            );
          },
          child: childWidget,
        );
      }

      /// only [onTapAnimationBuilder]
      else if(!animateOnAwait && !animateOnEvent){
        return AnimatedBuilder(
          animation: onTapController,
          builder: (context, child) {
            return widget.onTapAnimationBuilder(
              onTapController, 
              child,
            );
          },
          child: childWidget,
        );
      }
      
      /// only [onEventAnimationBuilder]
      else if(!animateOnAwait && !animateOntap){
        return AnimatedBuilder(
          animation: onEventController,
          builder: (context, child) {
            return widget.onEventAnimationBuilder(
              onEventController, 
              child,
            );
          },
          child: childWidget,
        );
      }

      else if(animateOnAwait && animateOntap && !animateOnEvent){
        return AnimatedBuilder(
          animation: onTapController,
          builder: (context, child) {
            return widget.onTapAnimationBuilder(
              onTapController, 
              AnimatedBuilder(
                animation: awaitController,
                builder: (context, child) {
                  return widget.awaitAnimationBuilder(
                    awaitController, 
                    child
                  );
                },
                child: child,
              )
            );
          },
          child: childWidget,
        );
      }

      else if(animateOnAwait && !animateOntap && animateOnEvent){
        return AnimatedBuilder(
          animation: onEventController,
          builder: (context, child) {
            return widget.onEventAnimationBuilder(
              onEventController, 
              AnimatedBuilder(
                animation: awaitController,
                builder: (context, child) {
                  return widget.awaitAnimationBuilder(
                    awaitController,
                    child,
                  );
                },
                child: child,
              )
            );
          },
          child: childWidget,
        );
      }
      
      else if(!animateOnAwait && animateOntap && animateOnEvent){
        return AnimatedBuilder(
          animation: onEventController,
          builder: (context, child) {
            return widget.onEventAnimationBuilder(
              onEventController, 
              AnimatedBuilder(
                animation: onTapController,
                builder: (context, child) {
                  return widget.onTapAnimationBuilder(
                    onTapController, 
                    child
                  );
                },
                child: child,
              )
            );
          },
          child: childWidget,
        );
      }

      else if(animateOnAwait && animateOntap && animateOnEvent){
        return AnimatedBuilder(
          animation: onEventController,
          builder: (context, child) {
            return widget.onEventAnimationBuilder(
              onEventController, 
              AnimatedBuilder(
                animation: onTapController,
                builder: (context, child) {
                  return widget.onTapAnimationBuilder(
                    onTapController, 
                    AnimatedBuilder(
                      animation: awaitController,
                      builder: (context, child) {
                        return widget.awaitAnimationBuilder(
                          awaitController,
                          child,
                        );
                      },
                      child: child
                    )
                  );
                },
                child: child,
              )
            );
          },
          child: childWidget,
        );
      }
      
    }

    return AnimatedBuilder(
      animation: onTapController,
      builder: (context, child) {
        if(state == EventAnimationState.INIT){
          return widget.initAnimationBuilder(initController, child);
        }
        else if(state == EventAnimationState.AWAITING || state == EventAnimationState.ON_TAP){
          return widget.onTapAnimationBuilder(
            onTapController, 
            widget.awaitAnimationBuilder(
              awaitController, 
              child
            ),
          );
        }
      },
      child: childWidget,
    );
  }

  void onTap(){
    if(animateOntap){
      setState(() {
        state = EventAnimationState.ON_TAP;
        onTapController.reset();
        onTapController.forward();
      });
    }
    if(widget.onTap != null)
      widget.onTap();
  }

  void onEvent(){
    if(animateOnEvent){
      setState(() {
        lastState = state;
        state = EventAnimationState.ON_EVENT;
        onEventController.reset();
        onEventController.forward();
      });
    }
  }
}