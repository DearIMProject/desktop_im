import 'dart:async';
import 'dart:convert';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_json_model.dart';
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
      Map<String, dynamic> decode = json.decode(message.content);
      SendJsonModel model = SendJsonModel.fromJson(decode);
      Tuple2<Message, int>? tuple2 = getMessageByMsgId(model.msgId);
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
    box.put(_getKey(mUserId, message), messages);
    Log.debug("数据库添加了一个消息 ${messages.last}");
  }

  @override
  void removeItem(item) {
    int mUserId = getMUserId(item);
    List<Message>? messages = _getMessages(item);
    if (messages.contains(item)) {
      messages.remove(item);
      box.put(_getKey(mUserId, item), messages);
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
      box.put(_getKey(mUserId, item), messages);
    }
  }

  /// 根据消息获取需要的userid
  int getMUserId(Message message) {
    int mUserId = 0;
    if (message.fromEntity == MessageEntityType.USER) {
      mUserId = message.fromId;
    }
    if (message.toEntity == MessageEntityType.USER) {
      if (mUserId == UserManager().uid() && message.toId != 0) {
        mUserId = message.toId;
      }
    } else {
      mUserId = message.toId;
    }
    if (message.entityId != 0) {
      mUserId = message.entityId;
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
          tuple = Tuple2(message, int.parse(uidStr.split("_").first));
          // break;
        }
        resultMessages.insert(0, message);
      }
      if (tuple != null) {
        break;
      }
    }
    if (tuple != null) {
      box.put(_getKey(tuple.item2, tuple.item1), resultMessages);
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
          tuple = Tuple2(message, int.parse(uidStr.split("_").first));
        }
        resultMessages.insert(0, message);
      }
    }
    return tuple;
  }

  Tuple2<Message, int>? getMessageByMsgId(int msgId) {
    List keys = box.keys.toList();
    Tuple2<Message, int /*userId*/ >? tuple;
    for (var i = 0; i < keys.length; i++) {
      String uidStr = keys[i];
      List? messages = box.get(uidStr);
      if (messages == null || messages.isEmpty) {
        return null;
      }
      for (var i = messages.length - 1; i >= 0; i--) {
        Message message = messages[i];
        if (message.msgId == msgId) {
          tuple = Tuple2(message, int.parse(uidStr.split("_").first));
          break;
        }
      }
    }
    return tuple;
  }

  /// 获取用户userId的所有消息
  List<Message> getMessages(String key) {
    var list = box.get(key);
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
    List<dynamic>? list = box.get(_getKey(mUserId, message));
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
  List<String> getChatEntityIds() {
    List<String> chatChatEntityIds = [];
    for (var e in box.keys) {
      if (e is String) {
        chatChatEntityIds.add(e);
      }
    }
    return chatChatEntityIds;
  }

  /// 获取用户最新信息（有内容的信息）
  Message? getLastMessage(String key) {
    List? messages = box.get(key);
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
      SendJsonModel model, MessageSendStatus status) async {
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
      int parse = _userIdFromKey(element);
      if (UserManager().uid() == parse) {
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

  int _userIdFromKey(String key) {
    return int.parse(key.split("_").first);
  }

  /// 判断是否为未读消息
  bool isUnreadMessage(Message message) {
    if (message.isNeedSendReadedMessage) {
      return true;
    }
    return false;
  }

  int getUserUnReadMessageCount(String key) {
    if (key == "${UserManager().uid()}_0") {
      return 0;
    }
    List? list = box.get(key);
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
    int userId = aMessage.entityId;
    int myUserId = UserManager().uid();
    List? list = box.get(_getKey(userId, aMessage));
    if (list == null) {
      return;
    }
    List<Message> messages = [];
    for (Message message in list.reversed) {
      if (message.timestamp == aMessage.timestamp) {
        String mReadUserIds = message.mReadUserIds;
        if (mReadUserIds.isEmpty) {
          mReadUserIds = "$myUserId";
        } else {
          if (!message.readUserIds.contains(myUserId)) {
            mReadUserIds += ",$myUserId";
          }
        }
        message.mReadUserIds = mReadUserIds;
      }
      messages.insert(0, message);
    }
    box.put(_getKey(userId, aMessage), messages);
  }

  String _getKey(int userId, Message aMessage) {
    int type = 0;
    if (aMessage.fromEntity == MessageEntityType.GROUP ||
        aMessage.toEntity == MessageEntityType.GROUP ||
        aMessage.entityType == MessageEntityType.GROUP) {
      // 这里需要判断entityType
      type = 1;
    }
    return "${userId}_$type";
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

  bool hasContentMessage(String key) {
    List? messages = box.get(key);
    if (messages == null || messages.isEmpty) {
      return false;
    }
    for (Message message in messages) {
      if (message.isChatMessage) {
        return true;
      }
    }

    return false;
  }
}
