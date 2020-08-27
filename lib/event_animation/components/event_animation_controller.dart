import 'dart:async';

import 'package:flutter/material.dart';

class EventAnimationController {
  StreamController<dynamic> changeNotifier;

  EventAnimationController({bool broadcast = false}) {
    if (broadcast)
      changeNotifier = StreamController.broadcast();
    else
      changeNotifier = StreamController();
  }

  void animateOnEvent() {
    changeNotifier.add(null);
  }
}
