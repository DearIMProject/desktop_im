import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/user/user_manager.dart';

class MessageFactory {
  static Message messageFromType(MessageType messageType) {
    Message? message;
    switch (messageType) {
      case MessageType.REQUEST_LOGIN:
        message = RequestLoginMessage();
        message.fromId = UserManager.getInstance().uid();
        message.fromEntity = MessageEntityType.USER;
        message.content = UserManager.getInstance().userToken();
        Log.debug(message.content);
        break;
      case MessageType.CHAT_MESSAGE:
        message = ChatMessage();
        break;
      case MessageType.FILE:
        message = FileMessage();
        break;
      case MessageType.HEART_BEAT:
        message = HeartBeatMessage();
        break;
      case MessageType.LINK:
        message = LinkMessage();
        break;
      case MessageType.PICTURE:
        message = PictureMessage();
        break;
      case MessageType.READED_MESSAGE:
        message = ReadedMessage();
        break;
      case MessageType.REQUEST_OFFLINE_MESSAGES:
        message = RequestOfflineMessage();
        break;
      case MessageType.SEND_SUCCESS_MESSAGE:
        message = SendSuccessMessage();
        break;
      case MessageType.TRANSPARENT_MESSAGE:
        message = TransparendMessage();
        break;
      case MessageType.TEXT:
      default:
        message = TextMessage();
        break;
    }
    message.timestamp = DateTime.now().millisecondsSinceEpoch;
    return message;
  }
}
