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

  void triggerForwardEvent() {
    changeNotifier.add(1);
  }

  void triggerBackwardEvent() {
    changeNotifier.add(-1);
  }
}
