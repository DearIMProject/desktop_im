import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/user/user_manager.dart';

class Message {
  // @TableId(value = "msgId", type = IdType.AUTO)
  int msgId = 0;
  int fromId = 0;
  // @TableField(typeHandler = MessageEntityTypeHandler.class)
  MessageEntityType fromEntity = MessageEntityType.USER;
  int toId = 0;
  // @TableField(typeHandler = MessageEntityTypeHandler.class)
  MessageEntityType toEntity = MessageEntityType.USER;
  /*消息内容*/
  String content = "";
  // @TableField(typeHandler = MessageTypeHandler.class)
  MessageType messageType = MessageType.TEXT;
  int timestamp = 0;
  // @TableField(typeHandler = MessageStatusTypeHandler.class)
  MessageStatus status = MessageStatus.STATUS_SUCCESS_UNREADED;

/* 以下变量不为数据库所持有 */

  // 是否是本人发出的消息
  bool get isOwner {
    if (fromId == UserManager.getInstance().uid()) {
      return true;
    }
    return false;
  }
}

class TextMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.TEXT;
  }
}

class RequestLoginMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.REQUEST_LOGIN;
  }
}

class ChatMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.CHAT_MESSAGE;
  }
}

class FileMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.FILE;
  }
}

class HeartBeatMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.HEART_BEAT;
  }
}

class LinkMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.LINK;
  }
}

class PictureMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.PICTURE;
  }
}

class ReadedMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.READED_MESSAGE;
  }
}

class RequestOfflineMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.REQUEST_OFFLINE_MESSAGES;
  }
}

class SendSuccessMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.SEND_SUCCESS_MESSAGE;
  }
}

class TransparendMessage extends Message {
  @override
  MessageType get messageType {
    return MessageType.TRANSPARENT_MESSAGE;
  }
}
