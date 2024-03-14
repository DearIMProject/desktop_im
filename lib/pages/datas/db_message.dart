import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_success_model.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:hive/hive.dart';
import 'package:tuple/tuple.dart';

class MessageDB implements DbProtocol<Message> {
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

  @override
  void addItem(message) {
    Log.debug("调用添加元素addItem $message");
    // 登录、离线、透传消息、心跳不记录在数据库中
    if (message.messageType == MessageType.REQUEST_LOGIN ||
        message.messageType == MessageType.REQUEST_OFFLINE_MESSAGES ||
        message.messageType == MessageType.TRANSPARENT_MESSAGE ||
        message.messageType == MessageType.HEART_BEAT) {
      Log.debug("消息不记录在数据库中");
      return;
    }
    // 消息为已读消息，则需要把该消息的时间戳获取到，找到对应的消息，标为已读
    if (message.messageType == MessageType.READED_MESSAGE) {
      Log.debug("消息为已读消息");
      var timestamp = message.timestamp;
      Tuple2<Message, int>? tuple2 = getMessageByTimestamp(timestamp);
      if (tuple2 != null) {
        setMessageReaded(tuple2.item1);
      }
    }
    // 如果消息为发送成功消息，则需要将消息状态改成成功
    if (message.messageType == MessageType.SEND_SUCCESS_MESSAGE) {
      var timestamp = message.timestamp;
      Log.debug("消息状态修改为发送成功");
      _updateMessageSendStatus(
          timestamp, MessageSendStatus.STATUS_SEND_SUCCESS);
    }

    int mUserId = getMUserId(message);
    List<Message>? messages = _getMessages(message);
    messages.add(message);
    box.put("$mUserId", messages);
    Log.debug("数据库添加了一个消息 ${messages.last}");
  }

  @override
  void removeItem(item) {
    int mUserId = getMUserId(item);
    List<Message>? messages = _getMessages(item);
    if (messages.contains(item)) {
      messages.remove(item);
      box.put("$mUserId", messages);
    }
  }

  @override
  void updateItem(item) {
    int mUserId = getMUserId(item);
    List<Message>? messages = _getMessages(item);
    if (messages.contains(item)) {
      int index = -1;
      for (var i = 0; i < messages.length; i++) {
        Message message = messages[i];
        if (message.timestamp == item.timestamp) {
          index = i;
          break;
        }
      }
      messages[index] = item;
      box.put("$mUserId", messages);
    }
  }

  /// 根据消息获取需要的userid
  int getMUserId(Message message) {
    int mUserId = message.fromId;
    if (mUserId == UserManager.getInstance().uid() && message.toId != 0) {
      mUserId = message.toId;
    }
    return mUserId;
  }

  /// 根据时间戳找到对应的消息，并更新消息发送状态
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
    if (tuple != null) {
      box.put("${tuple.item2}", resultMessages);
      return tuple;
    }
    return null;
  }

  /// 根据时间戳获取消息
  Tuple2<Message, int /*userId*/ >? getMessageByTimestamp(int timestamp) {
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
          tuple = Tuple2(message, int.parse(uidStr));
        }
        resultMessages.insert(0, message);
      }
    }
    return tuple;
  }

  /// 获取用户userId的所有消息
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

  /// 根据某一个发送的消息获取所有与该用户的消息
  List<Message> _getMessages(Message message) {
    int mUserId = getMUserId(message);
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

  /// 获取消息中最大的时间戳
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

  /// 获取所有有聊天内容的用户id
  List<int> getChatUsers() {
    List<int> chatUserIds = [];
    for (var e in box.keys) {
      if (e is String) {
        chatUserIds.add(int.parse(e));
      }
    }
    return chatUserIds;
  }

  /// 获取用户最新信息（有内容的信息）
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
        if (lastMessage.timestamp < message.timestamp &&
            message.isChatMessage) {
          lastMessage = message;
        }
      }
    }
    if (lastMessage != null && lastMessage.isChatMessage) {
      return lastMessage;
    }
    return null;
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

  /// 获取未读消息数量
  int getUnReadMessageCount() {
    int result = 0;
    for (String element in box.keys) {
      int parse = int.parse(element);
      if (UserManager.getInstance().uid() == parse) {
        continue;
      }
      List list = box.get(element)!;
      for (Message message in list) {
        if (isUnreadMessage(message)) {
          result++;
        }
      }
    }
    return result;
  }

  /// 判断是否为未读消息
  bool isUnreadMessage(Message message) {
    return (message.status == MessageStatus.STATUS_SUCCESS_UNREADED &&
        message.toId == UserManager.getInstance().uid());
  }

  int getUserUnReadMessageCount(int userId) {
    if (userId == UserManager.getInstance().uid()) {
      return 0;
    }
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

  void setMessageReaded(Message aMessage) {
    int userId = aMessage.fromId;
    List list = box.get("$userId")!;
    List<Message> messages = [];
    for (Message message in list.reversed) {
      if (message.timestamp == aMessage.timestamp) {
        message.status = MessageStatus.STATUS_SUCCESS_READED;
      }
      messages.insert(0, message);
    }
    box.put("$userId", messages);
  }

  @override
  Message? getItem(int id) {
    // TODO: implement getItem
    throw UnimplementedError();
  }

  @override
  List<Message> getItems() {
    // TODO: implement getItems
    throw UnimplementedError();
  }

  @override
  Future<int> deleteAllDatas() {
    return box.clear();
  }
}
