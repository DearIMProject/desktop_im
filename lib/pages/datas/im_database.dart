import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_success_model.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/db_message.dart';
import 'package:desktop_im/pages/datas/db_user.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

typedef DatabaseUnreadMessageNumberChange = void Function(int unreadNumber);
typedef DatabaseCompleteCallback = void Function();

abstract class IMDatabaseListener {
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  DatabaseCompleteCallback? completeCallback;
  DatabaseCompleteCallback? dataChangeCallback;
}

class IMDatabase implements IMClientListener {
  @override
  IMClientReceiveMessageCallback? messageCallback;
  @override
  IMClientUnReadedMessageCallback? unreadMessageCallback;
  @override
  IMClientConnectSuccessCallback? connectSuccessCallback;

  bool dbHasInstalled = false;

  // 初始化
  static IMDatabase? _instance;
  static IMDatabase getInstance() {
    _instance ??= IMDatabase();
    return _instance!;
  }

  final List<IMDatabaseListener> _listeners = [];

  /// 添加一个监听
  addListener(IMDatabaseListener listener) {
    if (!_listeners.contains(listener)) {
      // Log.debug("添加一个listener = $listener");
      _listeners.add(listener);
    }
  }

  /// 删除一个监听
  removeListener(IMDatabaseListener listener) {
    if (_listeners.contains(listener)) {
      // Log.debug("移除一个listener = $listener");
      _listeners.remove(listener);
    }
  }

  // 未读消息
  int _badgeValue = 0;
  int get badgeValue {
    _badgeValue = _dbMessage.getUnReadMessageCount();
    return _badgeValue;
  }

  final MessageDB _dbMessage = MessageDB();
  final UserDB _dbUser = UserDB();

  Future<void> _initialDatabase(String boxName) {
    Completer<void> completer = Completer<void>();

    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(MessageStatusAdapter());
    Hive.registerAdapter(MessageTypeAdapter());
    Hive.registerAdapter(MessageEntityTypeAdapter());
    Hive.registerAdapter(MessageSendStatusAdapter());
    _dbMessage.install(boxName).then((value) {
      _dbUser.install(boxName).then((value) {
        Log.info("初始化数据库完毕！");
        initBadgeValue();
        dbHasInstalled = true;
        completer.complete();
        Log.debug("Listeners = $_listeners");
        for (var i = 0; i < _listeners.length; i++) {
          IMDatabaseListener listener = _listeners[i];
          if (listener.completeCallback != null) {
            listener.completeCallback!();
          }
        }
      });
    });

    return completer.future;
  }

  void initBadgeValue() {
    _badgeValue = _dbMessage.getUnReadMessageCount();
  }

  Future<void> install(String boxName) async {
    if (dbHasInstalled) {
      return;
    }
    if (boxName.isEmpty) {
      return;
    }
    Log.info("开始初始化数据库...");
    messageCallback = (message) {
      addMessage(message);
    };
    // 获取未读信息
    unreadMessageCallback ??= (unreadNumber) {
      _badgeValue = unreadNumber;
      for (IMDatabaseListener listener in _listeners) {
        if (listener.unreadMessageNumberChange != null) {
          listener.unreadMessageNumberChange!(unreadNumber);
        }
      }
    };
    await _initialDatabase(boxName);
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

  /// 添加一条消息
  void addMessage(Message message) {
    _dbMessage.addItem(message);
    int userId = _dbMessage.getMUserId(message);
    User? user = _dbUser.getItem(userId);
    if (user != null) {
      _dbUser.updateItem(user);
    }
    // 告诉监听消息添加
    for (var i = 0; i < _listeners.length; i++) {
      IMDatabaseListener listener = _listeners[i];
      if (listener.dataChangeCallback != null) {
        listener.dataChangeCallback!();
      }
    }
    if (message.status == MessageStatus.STATUS_SUCCESS_UNREADED &&
        message.toId == UserManager.getInstance().uid()) {
      _badgeValue = _dbMessage.getUnReadMessageCount();
      for (IMDatabaseListener listener in _listeners) {
        if (listener.unreadMessageNumberChange != null) {
          listener.unreadMessageNumberChange!(_badgeValue);
        }
      }
    }
  }

  List<Message> getMessages(int userId) {
    return _dbMessage.getMessages(userId);
  }

  List<Message> getChatMessages(int userId) {
    List<Message> messages = _dbMessage.getMessages(userId);
    List<Message> result = [];
    for (var i = 0; i < messages.length; i++) {
      Message message = messages[i];
      result.add(message);
    }
    return result;
  }

  List<User> getChatUsers() {
    List<User> chatUsers = [];
    List<int> chatUserIds = _dbMessage.getChatUsers();
    for (var i = 0; i < chatUserIds.length; i++) {
      int chatUserId = chatUserIds[i];
      User? chatUser = _dbUser.getItem(chatUserId);
      if (chatUser != null) {
        chatUsers.add(chatUser);
      }
    }
    return chatUsers;
  }

// 获取消息列表最新的时间戳
  int getMaxTimestamp() {
    return _dbMessage.maxTimestamp();
  }

  Future<int> removeAll() async {
    int removeSuccess = await _dbMessage.deleteAllDatas();
    Log.debug("remove = $removeSuccess");
    await User().removeAll();
    return _dbUser.deleteAllDatas();
  }

  /// 添加用户
  void addUser(User user) {
    _dbUser.addItem(user);
  }

  List<User> getUsers() {
    return _dbUser.getItems();
  }

  /// 获取用户最新的Message
  Message? getLastMessage(int userId) {
    return _dbMessage.getLastMessage(userId);
  }

// 设置消息发送成功
  void configMessageSendSuccess(
      SendSuccessModel model, MessageSendStatus status) {
    _dbMessage.configMessageSendSuccess(model, status);
    for (var i = 0; i < _listeners.length; i++) {
      IMDatabaseListener listener = _listeners[i];
      if (listener.dataChangeCallback != null) {
        listener.dataChangeCallback!();
      }
    }
  }

//获取userId下未读数量
  int unreadNumber(int userId) {
    return _dbMessage.getUserUnReadMessageCount(userId);
  }

// 设置消息为已读
  void setMessageReaded(Message message) {
    _dbMessage.setMessageReaded(message);
  }

  void configMessageReaded(SendSuccessModel model) {
    int timestamp = int.parse(model.content);
    Tuple2<Message, int>? tuple = _dbMessage.getMessageByTimestamp(timestamp);
    if (tuple != null) {
      setMessageReaded(tuple.item1);
      for (var i = 0; i < _listeners.length; i++) {
        IMDatabaseListener listener = _listeners[i];
        if (listener.dataChangeCallback != null) {
          listener.dataChangeCallback!();
        }
      }
    }
  }
}
