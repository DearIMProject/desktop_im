import 'dart:convert';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/notification/notification_service.dart';
import 'package:desktop_im/pages/datas/im_database.dart';

abstract class NotificationHelperListener {
  NotificationClickCallback? clickCallback;
}

class NotificationHelper
    implements IMDatabaseListener, NotificationServiceListener {
  static final NotificationHelper _instance = NotificationHelper._internal();
  final NotificationService _service = NotificationService();

  NotificationHelperListener? listener;

  @override
  DatabaseAddReadableMessage? addReadableCallback;

  @override
  DatabaseCompleteCallback? completeCallback;

  @override
  DatabaseCompleteCallback? dataChangeCallback;

  @override
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  factory NotificationHelper() {
    IMDatabase().addListener(_instance);
    return _instance;
  }
  NotificationHelper._internal();

  void init() {
    _service.init();
    _service.listener = this;
    addReadableCallback = (message) {
      Log.debug("receive a message : $message");
      User? user = IMDatabase().getUser(message.fromId);
      if (user != null) {
        String playload = jsonEncode(message.toJson());
        _service.sendALocalNotification((message.timestamp ~/ 1000),
            user.username, message.content, playload);
      }
    };
    clickCallback = (user) {
      if (listener != null && listener!.clickCallback != null) {
        listener!.clickCallback!(user);
      }
    };
  }

  @override
  NotificationClickCallback? clickCallback;

  void clearNotification() {
    _service.clearAllNotification();
  }
}
