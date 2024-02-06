import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_success_model.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:hive/hive.dart';
import 'package:tuple/tuple.dart';

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
      Message message = item;
      if (message.messageType == MessageType.REQUEST_LOGIN ||
          message.messageType == MessageType.REQUEST_OFFLINE_MESSAGES) {
        return;
      }
      int mUserId = _getMUserId(item);
      List<Message>? messages = _getMessages(item);
      messages.add(item);
      box.put("$mUserId", messages);
      Log.debug("数据库添加了一个消息 ${messages.last}");
    }
  }

  Tuple2<Message, int /*userId*/ >? _updateMessageSendStatus(
      int timestamp, MessageSendStatus status) {
    List keys = box.keys.toList();
    Tuple2<Message, int /*userId*/ >? tuple;
    List<Message> resultMessages = [];
    for (var i = 0; i < keys.length; i++) {
      String uidStr = keys[i];
      List? messages = box.get(uidStr);
      if (messages == null || messages.isEmpty) {
        return null;
      }
      resultMessages = [];
      for (var i = messages.length - 1; i >= 0; i--) {
        Message message = messages[i];
        if (message.timestamp == timestamp) {
          message.sendStatue = status;
          tuple = Tuple2(message, int.parse(uidStr));
        }
        resultMessages.insert(0, message);
      }
    }
    if (tuple != null && resultMessages.isNotEmpty) {
      box.put("${tuple.item2}", resultMessages);
      return tuple;
    }

    return null;
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
    //TODO: wmy
    // _getMessages(item);
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
    Log.debug("maxTimestamp = $maxTimestamp");
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

  void configMessageSendSuccess(
      SendSuccessModel model, MessageSendStatus status) async {
    Log.debug("model = $model");
    // 找到对应的message，标记为status
    Tuple2<Message, int>? tuple =
        _updateMessageSendStatus(model.timestamp, status);
    if (tuple != null) {
      Message findMessage = tuple.item1;
      findMessage.sendStatue = status;
      findMessage.msgId = model.msgId;
      Log.debug("设置message = $findMessage");
    }
  }

  int getUnReadMessageCount() {
    int result = 0;
    for (String element in box.keys) {
      List list = box.get(element)!;
      for (Message message in list) {
        if (isUnreadMessage(message)) {
          result++;
        }
      }
    }
    return result;
  }

  bool isUnreadMessage(Message message) {
    return (message.status == MessageStatus.STATUS_NOT_SEND_UNREAD &&
        message.toId == UserManager.getInstance().uid());
  }

  int getUserUnReadMessageCount(int userId) {
    List? list = box.get("$userId");
    if (list == null) {
      return 0;
    }
    int unreadNumber = 0;
    for (Message message in list) {
      if (isUnreadMessage(message)) {
        unreadNumber++;
      }
    }
    return unreadNumber;
  }
}
