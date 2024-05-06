import 'dart:async';
import 'dart:ffi';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/group.dart';
import 'package:desktop_im/models/message/chat_entity.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_json_model.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/db_group.dart';
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
typedef DatabaseAddReadableMessage = void Function(Message message);

abstract class IMDatabaseListener {
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  DatabaseCompleteCallback? completeCallback;
  DatabaseCompleteCallback? dataChangeCallback;
  DatabaseAddReadableMessage? addReadableCallback;
}

class IMDatabase implements IMClientListener {
  @override
  IMClientReceiveMessageCallback? messageCallback;
  @override
  IMClientUnReadedMessageCallback? unreadMessageCallback;
  @override
  IMClientConnectSuccessCallback? connectSuccessCallback;

  bool dbHasInstalled = false;

  static final IMDatabase _instance = IMDatabase._internal();

  factory IMDatabase() {
    return _instance;
  }

  IMDatabase._internal();

  // 初始化

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
  final GroupDB _dbGroup = GroupDB();
  bool hasRegister = false;
  Future<void> _initialDatabase(String boxName) {
    Completer<void> completer = Completer<void>();
    if (!hasRegister) {
      Hive.registerAdapter(MessageAdapter());
      Hive.registerAdapter(GroupAdapter());
      Hive.registerAdapter(MessageStatusAdapter());
      Hive.registerAdapter(MessageTypeAdapter());
      Hive.registerAdapter(MessageEntityTypeAdapter());
      Hive.registerAdapter(MessageSendStatusAdapter());
      hasRegister = true;
    }
    _dbMessage.install(boxName).then((value) {
      _dbUser.install(boxName).then((value) {
        _dbGroup.install(boxName).then((value) {
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
    IMClient().addListener(this);
  }

  void uninstall() {
    _dbMessage.uninstall();
    _dbUser.uninstall();
    _dbGroup.uninstall();
    dbHasInstalled = false;
  }

  /// 添加一条消息
  void addMessage(Message message) {
    _dbMessage.addItem(message);
    int userId = _dbMessage.getMUserId(message);
    if (message.entityType == MessageEntityType.USER) {
      User? user = _dbUser.getItem(userId);
      if (user != null) {
        _dbUser.updateItem(user);
      }
    } else {
      //TODO: wmy
    }

    // 告诉监听消息添加
    for (var i = 0; i < _listeners.length; i++) {
      IMDatabaseListener listener = _listeners[i];
      if (listener.dataChangeCallback != null) {
        listener.dataChangeCallback!();
      }
    }
    // 未读信息改变
    if (!message.readUserIds.contains(UserManager().uid()) &&
        message.toId == UserManager().uid()) {
      _badgeValue = _dbMessage.getUnReadMessageCount();
      for (IMDatabaseListener listener in _listeners) {
        if (listener.unreadMessageNumberChange != null) {
          listener.unreadMessageNumberChange!(_badgeValue);
        }
      }
    }

    if (!message.isOwner && message.isChatMessage) {
      //TODO: wmy

      for (IMDatabaseListener listener in _listeners) {
        if (listener.addReadableCallback != null) {
          Log.debug("转发消息 $message");
          listener.addReadableCallback!(message);
        }
      }
    }
  }

  List<Message> getMessages(String key) {
    return _dbMessage.getMessages(key);
  }

  List<Message> getChatMessages(String key) {
    List<Message> messages = _dbMessage.getMessages(key);
    List<Message> result = [];
    for (var i = 0; i < messages.length; i++) {
      Message message = messages[i];
      if (message.isChatMessage) {
        result.add(message);
      }
    }
    return result;
  }

  List<ChatEntity> getChatEntitys() {
    List<ChatEntity> chatEntitys = [];
    List<String> chatEntityIds = _dbMessage.getChatEntityIds();
    for (var i = 0; i < chatEntityIds.length; i++) {
      String chatEntityId = chatEntityIds[i];
      List<String> entityIds = chatEntityId.split("_");
      int entityId = int.parse(entityIds.first);
      int type = int.parse(entityIds.last);
      if (type == 0) {
        User? chatUser = _dbUser.getItem(entityId);
        if (chatUser != null) {
          chatEntitys.add(chatUser);
        }
      } else if (type == 1) {
        Group? group = _dbGroup.getItem(entityId);
        if (group != null) {
          chatEntitys.add(group);
        }
      }
    }
    // 做最后消息的排序
    chatEntitys.sort((a, b) {
      Message? aMessage = getLastMessage(a.getKey());
      Message? bMessage = getLastMessage(b.getKey());
      if (aMessage == null || bMessage == null) {
        return 0;
      } else if (aMessage.timestamp > bMessage.timestamp) {
        return -1;
      } else if (bMessage.timestamp > aMessage.timestamp) {
        return 1;
      }
      return 0;
    });
    return chatEntitys;
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

  User? getUser(int userId) {
    return _dbUser.getItem(userId);
  }

  List<User> getUsers() {
    return _dbUser.getItems();
  }

  /// 获取用户最新的Message
  Message? getLastMessage(String key) {
    return _dbMessage.getLastMessage(key);
  }

  bool hasContextMessage(String key) {
    return _dbMessage.hasContentMessage(key);
  }

// 设置消息发送成功
  void configMessageSendSuccess(SendJsonModel model, MessageSendStatus status) {
    _dbMessage.configMessageSendSuccess(model, status);
    for (var i = 0; i < _listeners.length; i++) {
      IMDatabaseListener listener = _listeners[i];
      if (listener.dataChangeCallback != null) {
        listener.dataChangeCallback!();
      }
    }
  }

//获取userId下未读数量
  int unreadNumber(String key) {
    return _dbMessage.getUserUnReadMessageCount(key);
  }

// 设置消息为已读
  void setMessageReaded(Message message) {
    _dbMessage.setMessageReaded(message);
  }

  void configMessageReaded(SendJsonModel model) {
    int msgId = model.msgId;
    Tuple2<Message, int>? tuple = _dbMessage.getMessageByMsgId(msgId);
    // Tuple2<Message, int>? tuple = _dbMessage.getMessageByTimestamp(timestamp);
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

  void removeMessage(Message message) {
    _dbMessage.removeItem(message);
    for (var i = 0; i < _listeners.length; i++) {
      IMDatabaseListener listener = _listeners[i];
      if (listener.dataChangeCallback != null) {
        listener.dataChangeCallback!();
      }
    }
  }

  @override
  IMClientTransparentCallback? transparentCallback;

  /// 保存群组
  void saveGroup(Group group) {
    _dbGroup.addItem(group);
  }

  void saveGroups(List<Group> groups) {
    for (var i = 0; i < groups.length; i++) {
      Group group = groups[i];
      saveGroup(group);
    }
  }
}
