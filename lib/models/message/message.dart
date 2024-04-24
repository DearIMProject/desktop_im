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
  Message(
      [this.msgId = 0,
      this.fromId = 0,
      this.fromEntity = MessageEntityType.USER,
      this.toId = 0,
      this.toEntity = MessageEntityType.USER,
      this.content = "",
      this.messageType = MessageType.TEXT,
      this.timestamp = 0,
      this.status = MessageStatus.STATUS_NOT_SEND_UNREAD,
      this.sendStatue = MessageSendStatus.STATUS_SEND_ING,
      this.entityId = 0,
      this.entityType = MessageEntityType.USER]);
  @HiveField(0)
  int msgId = 0;

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
  MessageStatus status = MessageStatus.STATUS_SUCCESS_UNREADED;

  @HiveField(9)
  MessageSendStatus sendStatue = MessageSendStatus.STATUS_SEND_ING;
  @HiveField(10)
  MessageEntityType entityType = MessageEntityType.USER;
  @HiveField(11)
  int entityId = 0;

/* 以下变量不为数据库所持有 */

  // 是否是本人发出的消息
  bool get isOwner {
    if (fromId == UserManager().uid()) {
      return true;
    }
    return false;
  }

  bool get isNeedSendReadedMessage {
    return status == MessageStatus.STATUS_NOT_SEND_UNREAD ||
        status == MessageStatus.STATUS_NOT_SEND_UNREAD;
  }

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
    return 'Message{msgId=$msgId, fromId=$fromId, fromEntity=$fromEntity, toId=$toId, toEntity=$toEntity, content=$content, messageType=$messageType, timestamp=$timestamp, status=$status, sendStatue=$sendStatue, entityType=$entityType, entityId=$entityId}';
  }
}
