import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/user/user_manager.dart';

class MessageFactory {
  static Message messageFromType(MessageType messageType) {
    Message message = Message();
    message.messageType = messageType;
    switch (messageType) {
      case MessageType.REQUEST_LOGIN:
        message.fromId = UserManager().uid();
        message.fromEntity = MessageEntityType.USER;
        message.content = UserManager().userToken();
        // Log.debug("token=${message.content}");
        break;
      case MessageType.CHAT_MESSAGE:
        break;
      case MessageType.FILE:
        break;
      case MessageType.HEART_BEAT:
        break;
      case MessageType.LINK:
        break;
      case MessageType.PICTURE:
        break;
      case MessageType.READED_MESSAGE:
        break;
      case MessageType.REQUEST_OFFLINE_MESSAGES:
        message.fromId = UserManager().uid();
        message.fromEntity = MessageEntityType.USER;
        message.content = UserManager().userToken();
        break;
      case MessageType.SEND_SUCCESS_MESSAGE:
        break;
      case MessageType.TRANSPARENT_MESSAGE:
        break;
      case MessageType.TEXT:
      default:
        break;
    }
    message.timestamp = DateTime.now().millisecondsSinceEpoch;
    return message;
  }
}
