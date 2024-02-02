import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/db_message.dart';
import 'package:desktop_im/pages/datas/db_user.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

typedef DatabaseUnreadMessageNumberChange = void Function(int unreadNumber);
typedef DatabaseCompleteCallback = void Function();

abstract class IMDatabaseListener {
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  DatabaseCompleteCallback? completeCallback;
}

class IMDatabase implements IMClientListener {
  @override
  IMClientReceiveMessageCallback? messageCallback;
  @override
  IMClientUnReadedMessageCallback? unreadMessageCallback;
  bool dbHasInstalled = false;

  // 初始化
  static IMDatabase? _instance;
  static IMDatabase getInstance() {
    _instance ??= IMDatabase();
    return _instance!;
  }

  List<IMDatabaseListener> listeners = [];
  addListener(IMDatabaseListener listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  removeListener(IMDatabaseListener listener) {
    if (listeners.contains(listener)) {
      listeners.remove(listener);
    }
  }

  // 未读消息
  int _badgeValue = 0;
  int get badgeValue => _badgeValue;

  int _unreadNumber = 0;
  int get unreadNumber => _unreadNumber;

  final MessageDB _dbMessage = MessageDB();
  final UserDB _dbUser = UserDB();

  Future<void> initialDatabase(String boxName) {
    Completer<void> completer = Completer<void>();

    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(MessageStatusAdapter());
    Hive.registerAdapter(MessageTypeAdapter());
    Hive.registerAdapter(MessageEntityTypeAdapter());
    _dbMessage.install(boxName).then((value) {
      _dbUser.install(boxName).then((value) {
        Log.info("初始化数据库完毕！");
        dbHasInstalled = true;
        completer.complete();
      });
    });

    return completer.future;
  }

  Future<void> install(String boxName) async {
    if (dbHasInstalled) {
      return;
    }
    Log.info("开始初始化数据库...");
    messageCallback = (message) {
      addMessage(message);
    };
    // 获取未读信息
    unreadMessageCallback = (unreadNumber) {
      _unreadNumber = unreadNumber;
      for (IMDatabaseListener listener in listeners) {
        if (listener.unreadMessageNumberChange != null) {
          listener.unreadMessageNumberChange!(unreadNumber);
        }
      }
    };
    await initialDatabase(boxName);
  }

  Future<void> init() async {
    Log.debug("database init");
    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    IMClient.getInstance().addListener(this);
  }

  void uninstall() {
    _dbMessage.uninstall();
    _dbUser.uninstall();
  }

  // 添加一条消息
  void addMessage(Message message) {
    _dbMessage.addItem(message);
    _badgeValue++;
  }

  List<Message> getMessages(int userId) {
    return _dbMessage.getMessages(userId);
  }

// 获取消息列表最新的时间戳
  int getMaxTimestamp() {
    return _dbMessage.maxTimestamp();
  }

  Future<int> removeAll() async {
    await _dbMessage.deleteAll();
    await User().removeAll();
    return _dbUser.deleteAll();
  }
}
