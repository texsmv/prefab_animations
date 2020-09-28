import 'dart:async';

class EventLauncher {
  bool broadcast;
  StreamController<dynamic> changeNotifier;

  EventLauncher({this.broadcast = false}) {
    if (broadcast)
      changeNotifier = StreamController.broadcast();
    else
      changeNotifier = StreamController();
  }

  void forward() {
    changeNotifier.add(1);
  }

  void backward() {
    changeNotifier.add(-1);
  }

  void dispose() {
    changeNotifier.close();
  }
}
