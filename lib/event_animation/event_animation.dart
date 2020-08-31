library prefab_animations;

import 'dart:async';

import 'package:flutter/material.dart';

import 'components/event_animation_controller.dart';
import 'constants/event_animation_states.dart';

class EventAnimation extends StatefulWidget {
  /// Widget that will be animated
  Widget child;

  /// Builder for the init animation
  ///
  /// the controller is provided and managed by the class and the child is
  /// the one provided
  Function(AnimationController controller, Widget child) initAnimationBuilder;

  /// Builder for the await animation
  ///
  /// the controller is provided and managed by the class and the child is
  /// the one provided
  Function(AnimationController controller, Widget child) awaitAnimationBuilder;

  /// Builder for the on tap animation
  ///
  /// the controller is provided and managed by the class and the child is
  /// the one provided
  Function(AnimationController controller, Widget child) onTapAnimationBuilder;

  /// Builder for the init animation
  ///
  /// the controller is provided and managed by the class and the child is
  /// the one provided. Yoo need to provide [eventStreamTrigger] to trigger
  /// this animation
  Function(AnimationController controller, Widget child)
      onEventAnimationBuilder;

  Duration initAnimationDuration;
  Duration awaitAnimationDuration;
  Duration onTapAnimationDuration;
  Duration onEventAnimationDuration;

  /// Init animation delay
  Duration initDelay;

  /// Delay to trigger the [onTap] function provided
  ///
  /// by default it is set to [onTapAnimationDuration]
  Duration onTapFunctionDelay;

  /// Function triggered on tap of the widget
  Function onTap;

  /// controller for the event animation
  ///
  /// set broadcast to true if the controller will be used in more than
  /// one [EventAnimation]s.
  EventAnimationController controller;

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
    this.initDelay,
    this.onTap = null,
    this.onTapFunctionDelay,
    this.controller,
  }) : super(key: key);

  @override
  _EventAnimationState createState() => _EventAnimationState();
}

class _EventAnimationState extends State<EventAnimation>
    with TickerProviderStateMixin {
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

  Duration onTapFunctionDelay;

  StreamSubscription streamSubscription;

  void initializeOnInit() {
    state = EventAnimationState.INIT;
    initController = AnimationController(
        vsync: this, duration: widget.initAnimationDuration);

    if (widget.initDelay != null)
      Future.delayed(widget.initDelay).then((_) => initController.forward());
    else
      initController.forward();

    if (animateOnAwait) {
      initController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          state = EventAnimationState.AWAITING;
          awaitController.forward();
        }
      });
    }
  }

  void initializeOnAwait() {
    awaitController = AnimationController(
        vsync: this, duration: widget.awaitAnimationDuration);

    awaitController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        awaitController.reset();
        awaitController.forward();
      }
    });

    if (!animateOnInit) {
      state = EventAnimationState.AWAITING;
      awaitController.forward();
    }
  }

  void initializeOnTap() {
    onTapController = AnimationController(
        vsync: this, duration: widget.onTapAnimationDuration);
    onTapController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          state = EventAnimationState.AWAITING;
          onTapController.reset();
        });
      }
    });
  }

  void initializeOnEvent() {
    onEventController = AnimationController(
        vsync: this, duration: widget.onEventAnimationDuration);
    onEventController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          state = lastState;
          onEventController.reset();
        });
      }
    });

    streamSubscription =
        widget.controller.changeNotifier.stream.listen((event) {
      onEvent();
    });
  }

  @override
  void initState() {
    animateOnInit = !(widget.initAnimationBuilder == null);
    animateOntap = !(widget.onTapAnimationBuilder == null);
    animateOnAwait = !(widget.awaitAnimationBuilder == null);
    animateOnEvent = (!(widget.controller == null) &&
        !(widget.onEventAnimationBuilder == null));

    if (widget.onTapFunctionDelay == null)
      onTapFunctionDelay = widget.onTapAnimationDuration;
    else
      onTapFunctionDelay = widget.onTapFunctionDelay;

    if (animateOnInit) {
      initializeOnInit();
    } else {
      state = EventAnimationState.AWAITING;
    }

    if (animateOnAwait) {
      initializeOnAwait();
    }

    if (animateOntap) {
      initializeOnTap();
    }

    if (animateOnEvent) {
      initializeOnEvent();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(EventAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (animateOnEvent) {
      if (widget.controller.changeNotifier.stream !=
          oldWidget.controller.changeNotifier.stream) {
        streamSubscription.cancel();
        streamSubscription =
            widget.controller.changeNotifier.stream.listen((_) {
          onEvent();
        });
      }
    }
    updateDurations();
  }

  @override
  void dispose() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
      widget.controller.changeNotifier.close();
    }

    if (onEventController != null) onEventController.dispose();
    if (awaitController != null) awaitController.dispose();
    if (initController != null) initController.dispose();
    if (onTapController != null) onTapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// tapable widget

    Widget childWidget = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: (widget.onTap != null)
          ? AbsorbPointer(child: widget.child)
          : widget.child,
      onTap: () {
        onTap();
      },
    );

    /// onInit state
    ///
    /// No other animations can be played
    if (state == EventAnimationState.INIT && animateOnInit) {
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
    else if (state == EventAnimationState.AWAITING ||
        state == EventAnimationState.ON_TAP ||
        state == EventAnimationState.ON_EVENT) {
      /// only [awaitAnimationBuilder]
      if (!animateOntap && !animateOnEvent) {
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
      else if (!animateOnAwait && !animateOnEvent) {
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
      else if (!animateOnAwait && !animateOntap) {
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
      } else if (animateOnAwait && animateOntap && !animateOnEvent) {
        return AnimatedBuilder(
          animation: onTapController,
          builder: (context, child) {
            return widget.onTapAnimationBuilder(
                onTapController,
                AnimatedBuilder(
                  animation: awaitController,
                  builder: (context, child) {
                    return widget.awaitAnimationBuilder(awaitController, child);
                  },
                  child: child,
                ));
          },
          child: childWidget,
        );
      } else if (animateOnAwait && !animateOntap && animateOnEvent) {
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
                ));
          },
          child: childWidget,
        );
      } else if (!animateOnAwait && animateOntap && animateOnEvent) {
        return AnimatedBuilder(
          animation: onEventController,
          builder: (context, child) {
            return widget.onEventAnimationBuilder(
                onEventController,
                AnimatedBuilder(
                  animation: onTapController,
                  builder: (context, child) {
                    return widget.onTapAnimationBuilder(onTapController, child);
                  },
                  child: child,
                ));
          },
          child: childWidget,
        );
      } else if (animateOnAwait && animateOntap && animateOnEvent) {
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
                            child: child));
                  },
                  child: child,
                ));
          },
          child: childWidget,
        );
      }
    }

    return AnimatedBuilder(
      animation: onTapController,
      builder: (context, child) {
        if (state == EventAnimationState.INIT) {
          return widget.initAnimationBuilder(initController, child);
        } else if (state == EventAnimationState.AWAITING ||
            state == EventAnimationState.ON_TAP) {
          return widget.onTapAnimationBuilder(
            onTapController,
            widget.awaitAnimationBuilder(awaitController, child),
          );
        }
      },
      child: childWidget,
    );
  }

  void onTap() {
    if (animateOntap) {
      setState(() {
        state = EventAnimationState.ON_TAP;
        onTapController.reset();
        onTapController.forward();
      });
    }
    if (widget.onTap != null) {
      if (onTapFunctionDelay != null)
        Future.delayed(onTapFunctionDelay).then((value) => widget.onTap());
      else
        widget.onTap();
    }
  }

  void onEvent() {
    if (animateOnEvent) {
      setState(() {
        lastState = state;
        state = EventAnimationState.ON_EVENT;
        onEventController.reset();
        onEventController.forward();
      });
    }
  }

  void updateDurations() {
    if (widget.onTapFunctionDelay == null)
      onTapFunctionDelay = widget.onTapAnimationDuration;
    else
      onTapFunctionDelay = widget.onTapFunctionDelay;
  }
}
