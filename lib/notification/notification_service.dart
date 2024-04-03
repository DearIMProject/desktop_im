import 'dart:convert';
import 'dart:io';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:desktop_im/models/message/message.dart' as Msg;

typedef NotificationClickCallback = void Function(User? user);

abstract class NotificationServiceListener {
  NotificationClickCallback? clickCallback;
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool hasInit = false;

  NotificationServiceListener? listener;

  void init() {
    if (hasInit) {
      return;
    }
    hasInit = true;
    if (Platform.isMacOS) {
    } else {
      checkPermission();
    }
  }

  void checkPermission() {
    Permission.notification.status.then((status) {
      if (status.isDenied) {
        Log.debug("用户拒绝通知权限");
        Permission.notification.request().then((value) {
          Log.debug("$value");
          if (value.isGranted) {
            initLocalNotification();
          }
        });
      }
      if (status.isGranted) {
        Log.debug("用户授予权限");
        initLocalNotification();
      }
      if (status.isPermanentlyDenied) {
        Log.debug("用户永久拒绝权限");
      }
    });
  }

  // get notification => Notification(title);

  void sendALocalNotification(
      int notificationId, String title, String boby, String playload) {
    // 安卓的通知
    // 'your channel id'：用于指定通知通道的ID。
    // 'your channel name'：用于指定通知通道的名称。
    // 'your channel description'：用于指定通知通道的描述。
    // Importance.max：用于指定通知的重要性，设置为最高级别。
    // Priority.high：用于指定通知的优先级，设置为高优先级。
    // 'ticker'：用于指定通知的提示文本，即通知出现在通知中心的文本内容。
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your.channel.id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    // ios的通知
    const String darwinNotificationCategoryPlain = 'plainCategory';
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain, // 通知分类
    );
    // 创建跨平台通知
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    // 发起一个通知
    _plugin.show(notificationId, title, boby, platformChannelSpecifics,
        payload: playload);
  }

  Future<void> initLocalNotification() async {
    Log.debug("initLocalNotification");
    // await requestIOSPermissions();

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // DarwinInitializationSettings macOS = iOS;
    // const linux =
    // LinuxInitializationSettings(defaultActionName: "defaultActionName");

    InitializationSettings initializationSettings =
        InitializationSettings(android: android, iOS: ios
            // , macOS: macOS, linux: linux
            );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        Log.debug("$details");
        onReceiveNotification(details.payload);
      },
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   Log.debug("$details");
      // },
    );
  }

  onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Log.debug("content");
  }

  void clearAllNotification() {
    _plugin.cancelAll();
  }

  void cancelNotification(int id, {String? tag}) {
    _plugin.cancel(id, tag: tag);
  }

  void onReceiveNotification(String? payload) {
    Map<String, dynamic> json = jsonDecode(payload!);
    Msg.Message message = Msg.Message.fromJson(json);
    Log.debug("$message");
    if (listener != null && listener!.clickCallback != null) {
      listener!.clickCallback!(IMDatabase().getUser(message.fromId));
    }
    clearAllNotification();
  }
}
