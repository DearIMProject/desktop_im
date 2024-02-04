import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:hive/hive.dart';

class MessageDB implements DbProtocol {
  // MessageDB();
  late Box<List> box;

  @override
  Future<void> install(String boxName) async {
    Completer<void> completer = Completer<void>();
    Hive.openBox<List>("message_$boxName").then((value) {
      box = value;
      Log.debug("初始化message_$boxName ，box = $box");
      completer.complete();
    });
    return completer.future;
  }

  @override
  void uninstall() {
    box.close();
  }

  int _getMUserId(Message message) {
    int mUserId = message.fromId;
    if (mUserId == UserManager.getInstance().uid()) {
      mUserId = message.toId;
    }
    return mUserId;
  }

  @override
  void addItem(item) {
    if (item is Message) {
      int mUserId = _getMUserId(item);
      List<Message>? messages = _getMessages(item);
      messages.add(item);
      box.put("$mUserId", messages);
      Log.debug("数据库添加了一个消息 $messages");
    }
  }

  @override
  void removeItem(item) {
    int mUserId = _getMUserId(item);
    List<Message>? messages = _getMessages(item);
    if (messages.contains(item)) {
      messages.remove(item);
      box.put("$mUserId", messages);
    }
  }

  @override
  void updateItem(item) {
    _getMessages(item);
  }

  List<Message> getMessages(int userId) {
    var list = box.get("$userId");
    List<Message> messages = [];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        Message m = list[i];
        messages.add(m);
      }
    }
    return messages;
  }

  List<Message> _getMessages(item) {
    Message message = item;
    int mUserId = _getMUserId(message);
    List<dynamic>? list = box.get("$mUserId");
    if (list == null) {
      return [];
    }
    List<Message>? messages = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i] is Message) {
        messages.add(list[i]);
      }
    }
    return messages;
  }

  int maxTimestamp() {
    List<List<dynamic>> list = box.values.toList();

    if (list.isEmpty) {
      return 0;
    }

    List<Message> result = [];
    for (List messages in list) {
      for (var i = 0; i < messages.length; i++) {
        var message = messages[i];
        if (message is Message) {
          result.add(message);
        }
      }
    }
    if (result.isEmpty) {
      return 0;
    }
    Message maxTimestamp = result.reduce((Message current, Message next) =>
        current.timestamp > next.timestamp ? current : next);
    return maxTimestamp.timestamp;
  }

  List<int> getChatUsers() {
    List<int> chatUserIds = [];
    for (var e in box.keys) {
      if (e is String) {
        chatUserIds.add(int.parse(e));
      }
    }
    return chatUserIds;
  }

  Future<int> deleteAll() {
    return box.clear();
  }

  Message? getLastMessage(int userId) {
    List? messages = box.get("$userId");
    if (messages == null || messages.isEmpty) {
      return null;
    }
    Message? lastMessage;
    for (var i = 0; i < messages.length; i++) {
      var message = messages[i];
      if (message is Message) {
        lastMessage ??= message;
        if (lastMessage.timestamp < message.timestamp) {
          lastMessage = message;
        }
      }
    }
    return lastMessage;
  }
}
