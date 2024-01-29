import 'package:desktop_im/models/message_enum.dart';

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
  int? timestamp;
  // @TableField(typeHandler = MessageStatusTypeHandler.class)
  MessageStatus status = MessageStatus.STATUS_SUCCESS_UNREADED;
}
