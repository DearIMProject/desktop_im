import 'dart:convert';

import 'package:desktop_im/models/fileBean.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Message extends HiveObject {
  Message([
    this.msgId = 0,
    this.fromId = 0,
    this.fromEntity = MessageEntityType.USER,
    this.toId = 0,
    this.toEntity = MessageEntityType.USER,
    this.content = "",
    this.messageType = MessageType.TEXT,
    this.timestamp = 0,
    this.status = MessageStatus.STATUS_SUCCESS,
    this.sendStatue = MessageSendStatus.STATUS_SEND_ING,
    this.entityId = 0,
    this.entityType = MessageEntityType.USER,
    this.mReadUserIds = "",
  ]);
  @HiveField(0)
  int msgId = 0;

  static const List<int> constUserIds = [];

  @HiveField(1)
  int fromId = 0;

  @HiveField(2)
  MessageEntityType fromEntity = MessageEntityType.USER;

  @HiveField(3)
  int toId = 0;

  @HiveField(4)
  MessageEntityType toEntity = MessageEntityType.USER;

  /*消息内容*/
  @HiveField(5)
  String content = "";

  @HiveField(6)
  MessageType messageType = MessageType.TEXT;

  @HiveField(7)
  int timestamp = 0;

  @HiveField(8)
  MessageStatus status = MessageStatus.STATUS_SUCCESS;

  @HiveField(9)
  MessageSendStatus sendStatue = MessageSendStatus.STATUS_SEND_ING;
  @HiveField(10)
  MessageEntityType entityType = MessageEntityType.USER;
  @HiveField(11)
  int entityId = 0;

  @HiveField(12)
  String mReadUserIds = "";

  List<int> _readUserIds = [];

  List<int> get readUserIds {
    if (_readUserIds.isEmpty) {
      if (mReadUserIds.isNotEmpty) {
        List<String> readUserIds = mReadUserIds.split(",");
        if (readUserIds.isNotEmpty) {
          _readUserIds = readUserIds.map((e) => int.parse(e)).toList();
        }
      }
    }
    return _readUserIds;
  }

  set setReadUserIds(String mReadUserIds) {
    mReadUserIds = mReadUserIds;
    List<String> readUserIds = mReadUserIds.split(",");
    if (readUserIds.isNotEmpty) {
      _readUserIds = readUserIds.map((e) => int.parse(e)).toList();
    }
  }

  String get getReadUserIds {
    if (mReadUserIds.isEmpty) {
      return "";
    }
    return mReadUserIds;
  }

/* 以下变量不为数据库所持有 */

  // 是否是本人发出的消息
  bool get isOwner {
    if (fromId == UserManager().uid()) {
      return true;
    }
    return false;
  }

  /// 是否需要发送已读消息
  bool get isNeedSendReadedMessage {
    if (!isNeedShowMessage) {
      return false;
    }
    if (isOwner) {
      return false;
    }
    if (readUserIds.isEmpty) {
      return true;
    }
    int userId = UserManager().uid();
    if (!readUserIds.contains(userId)) {
      return true;
    }
    return false;
  }

  bool get isNeedShowMessage {
    if (status == MessageStatus.STATUS_DELETE ||
        status == MessageStatus.STATUS_RECALL) {
      return false;
    }
    return true;
  }

  /// 是否是聊天消息
  bool get isChatMessage {
    if (messageType == MessageType.CHAT_MESSAGE ||
        messageType == MessageType.FILE ||
        messageType == MessageType.LINK ||
        messageType == MessageType.PICTURE ||
        messageType == MessageType.TEXT) {
      return true;
    }
    return false;
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  FileBean? get imageFileBean {
    if (messageType == MessageType.PICTURE) {
      Map<String, dynamic> json = jsonDecode(content);
      return FileBean.fromJson(json);
    }
    return null;
  }

  @override
  String toString() {
    return 'Message{msgId=$msgId,\n fromId=$fromId,\n fromEntity=$fromEntity,\n toId=$toId, \ntoEntity=$toEntity,\n content=$content, \nmessageType=$messageType,\n timestamp=$timestamp, \nstatus=$status,\n sendStatue=$sendStatue,\n entityType=$entityType, \nentityId=$entityId, \n_mReadUserIds=$mReadUserIds,\n _readUserIds=$_readUserIds}';
  }
}
