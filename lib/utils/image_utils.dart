import 'dart:async';
import 'dart:convert';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/fileBean.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/pages/message/services/message_service.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';

typedef LocalMessageCallback = void Function(Message message);

class ImageUtils {
  static Future<Message> sendFile(
    String filePath,
    int fromUserId,
    int toUserId,
    LocalMessageCallback callback,
  ) async {
    Completer<Message> completer = Completer();
    Message message =
        await _addAImageMessageBefore(filePath, fromUserId, toUserId);
    callback(message);
    _uploadImage(filePath).then((fileBean) {
      Log.debug("[picture]上传图片成功 $fileBean");
      if (fileBean != null) {
        _sendAImageMessage(message, fileBean);
        completer.complete(message);
      } else {
        completer.complete(message);
        //TODO: wmy
        // 上传失败
        // sendAImage(filePath);
      }
    });
    return completer.future;
  }

  static Future<Message> _addAImageMessageBefore(
    String filePath,
    int fromUserId,
    int toUserId,
  ) async {
    Completer<Message> completer = Completer();
    Message message = MessageFactory.messageFromType(MessageType.PICTURE);
    message.fromId = fromUserId;
    message.fromEntity = MessageEntityType.USER;
    message.toId = toUserId;
    message.toEntity = MessageEntityType.USER;
    FileBean fileBean = await FileBean.initFileBean(filePath);
    Log.debug(fileBean.toJson().toString());
    String content = jsonEncode(fileBean.toJson());
    message.content = content;
    completer.complete(message);
    Log.debug("[picture]本地添加一个消息 $message");
    return completer.future;
  }

  static Message _sendAImageMessage(Message message, FileBean fileBean) {
    Log.debug("[picture]发送图片");
    String content = jsonEncode(fileBean.toJson());
    message.content = content;
    Log.debug(content);
    // // 找到message 替换掉
    // int findIndex = -1;
    // for (var i = messages.length - 1; i >= 0; i--) {
    //   Message aMessage = messages[i];
    //   if (aMessage.timestamp == message.timestamp) {
    //     findIndex = i;
    //     break;
    //   }
    // }
    // messages[findIndex] = message;
    // message.content = content;
    // Log.debug("[picture]将本地消息进行更新 $messages");
    IMClient().sendMessage(message);
    Log.debug("[picture]发送了一个消息：$message");
    return message;
  }

  static Future<FileBean?> _uploadImage(String filePath) {
    Log.debug("[picture]上传图片 $filePath");
    Completer<FileBean?> completer = Completer();
    MessageService.uploadFile(filePath, ImageType.image).then((fileBean) {
      completer.complete(fileBean);
    });
    return completer.future;
  }
}
