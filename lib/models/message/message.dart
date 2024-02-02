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
      this.status = MessageStatus.STATUS_NOT_SEND_UNREAD]);
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

/* 以下变量不为数据库所持有 */

  // 是否是本人发出的消息
  bool get isOwner {
    if (fromId == UserManager.getInstance().uid()) {
      return true;
    }
    return false;
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return 'Message{msgId=$msgId, fromId=$fromId, fromEntity=$fromEntity, toId=$toId, toEntity=$toEntity, content=$content, messageType=$messageType, timestamp=$timestamp, status=$status}';
  }
}

// class TextMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.TEXT;
//   }
// }

// class RequestLoginMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.REQUEST_LOGIN;
//   }
// }

// class ChatMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.CHAT_MESSAGE;
//   }
// }

// class FileMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.FILE;
//   }
// }

// class HeartBeatMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.HEART_BEAT;
//   }
// }

// class LinkMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.LINK;
//   }
// }

// class PictureMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.PICTURE;
//   }
// }

// class ReadedMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.READED_MESSAGE;
//   }
// }

// class RequestOfflineMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.REQUEST_OFFLINE_MESSAGES;
//   }
// }

// class SendSuccessMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.SEND_SUCCESS_MESSAGE;
//   }
// }

// class TransparendMessage extends Message {
//   @override
//   MessageType get messageType {
//     return MessageType.TRANSPARENT_MESSAGE;
//   }
// }
