import 'dart:async';

class NotificationStream {
  static final NotificationStream _instance = NotificationStream._internal();

  factory NotificationStream() {
    return _instance;
  }

  NotificationStream._internal();

  final StreamController<String> _streamController =
      StreamController<String>.broadcast();

  Stream<String> get stream => _streamController.stream;

  void publish(String notification) {
    _streamController.add(notification);
  }

  void dispose() {
    _streamController.close();
  }
}
