import 'dart:convert';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_success_model.dart';
import 'package:desktop_im/notification/notification_stream.dart';
import 'package:desktop_im/notification/notifications.dart';
import 'package:desktop_im/pages/datas/im_database.dart';

import 'package:desktop_im/tcpconnect/connect/byte_buffer.dart';
import 'package:desktop_im/tcpconnect/connect/message_codec.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';
import 'package:desktop_im/tcpconnect/socket/socket_manager.dart';
import 'package:desktop_im/tcpconnect/socket/socket_protocol.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:desktop_im/utils/message_queue.dart';
import 'package:flutter/foundation.dart';

typedef IMClientReceiveMessageCallback = void Function(Message message);
typedef IMClientUnReadedMessageCallback = void Function(int unreadNumber);
// ignore: constant_identifier_names
const String MAGIC_NUMBER = "891013";

abstract class IMClientListener {
  IMClientReceiveMessageCallback? messageCallback;
  IMClientUnReadedMessageCallback? unreadMessageCallback;
}

class IMClient implements SocketListener {
  static IMClient? _instance;
  late SocketProtocol _socketManager;
  late MessageCodec _messageCodec;
  late ByteBuf _readByteBuf;
  IMDatabase database = IMDatabase.getInstance();
  @override
  SocketSuccessCallback? connectSuccess;
  @override
  SocketSendMessagesCallback? sendMessageSuccess;
  @override
  SocketReceiveCallback? receiveCallback;

  List<IMClientListener> listeners = [];
  final MessageQueue _messageQueue = MessageQueue();

  void addListener(IMClientListener listener) {
    if (listeners.contains(listener)) {
      return;
    }
    listeners.add(listener);
  }

  void removeListener(IMClientListener listener) {
    if (listeners.contains(listener)) {
      listeners.remove(listener);
    }
  }

  String host = "172.16.92.60";
  int port = 9999;

  static IMClient getInstance() {
    _instance ??= IMClient();
    return _instance!;
  }

  void dispose() {
    // _messageQueue.dispose();
  }

  void init() {
    _readByteBuf = ByteBuf.allocator(size: 100);
    _messageCodec = MessageCodec();
    _socketManager = SocketManager(host, port);
    _socketManager.listener = _instance;
    connectSuccess = () {
      Log.info("成功建立长连接！");
      //发送一个Login消息
      sendRequestLoginMessage();
    };
    sendMessageSuccess = (int timestamp) {
      Log.info("消息发送成功！ timestamp = $timestamp");
    };
    receiveCallback = (data) {
      if (data != null) {
        _readByteBuf.reset();
        _readByteBuf.writeUint8List(data);
      }
      if (_readByteBuf.couldReadableSize > 4) {
        // 说明长度至少在内
        int length = _readByteBuf.readInt();
        if (_readByteBuf.couldReadableSize >= length) {
          // 粘包
          ByteBuf asByteBuf = _readByteBuf.readUint8ListAsByteBuf(length);
          receiveData(asByteBuf.readAllUint8List());
          if (_readByteBuf.couldReadableSize != 0) {
            ByteBuf restByteBuf = _readByteBuf
                .readUint8ListAsByteBuf(_readByteBuf.couldReadableSize);
            _readByteBuf.clear();
            _readByteBuf.writeUint8List(restByteBuf.readAllUint8List());
            receiveCallback!(null);
          } else {
            _readByteBuf.clear();
          }
        } else {
          // 半包
        }
      }
    };
  }

  void sendRequestLoginMessage() {
    _sendRequestLoginMessge();
  }

  Future<void> _sendRequestLoginMessge() async {
    Message messageFromType =
        MessageFactory.messageFromType(MessageType.REQUEST_LOGIN);
    sendMessage(messageFromType);
  }

  void receiveData(Uint8List aData) {
    Message? message = _messageCodec.decode(aData);
    if (message == null) {
      return;
    }
    switch (message.messageType) {
      case MessageType.TEXT:
        configReceiveTextMessage(message);
        break;
      case MessageType.REQUEST_LOGIN:
        configReceiveRequestLoginMessage(message);
        break;
      case MessageType.SEND_SUCCESS_MESSAGE:
        configReceiveSendSuccessMessage(message);
        break;

      default:
    }
  }

  void configReceiveTextMessage(Message message) {
    message.sendStatue = MessageSendStatus.STATUS_SEND_SUCCESS;
    Log.info("收到一个消息 = $message");
    if (listeners.isNotEmpty) {
      for (IMClientListener listener in listeners) {
        if (listener.messageCallback != null) {
          listener.messageCallback!(message);
        }
      }
    }
  }

  void configReceiveRequestLoginMessage(Message message) {
    Log.debug("收到登录消息 configReceiveRequestLoginMessage");

    if (message.content.contains(MAGIC_NUMBER)) {
      sendRequestOfflineMessage();
    } else {
      // 登录失败
      String token = UserManager.getInstance().userToken();
      if (token.isNotEmpty) {
        autologin(token);
      } else {
        NotificationStream().publish(kLogoutSuccessNotification);
      }
    }
  }

  void autologin(String token) {
    LoginService.autoLogin(token, Callback(
      successCallback: () {
        sendRequestLoginMessage();
      },
    ));
  }

  void sendRequestOfflineMessage() {
    Log.debug("发送获取离线消息 sendRequestOfflineMessage");
    Message messageFromType =
        MessageFactory.messageFromType(MessageType.REQUEST_OFFLINE_MESSAGES);
    messageFromType.timestamp = database.getMaxTimestamp();
    Log.debug("timestamp = ${messageFromType.timestamp}");

    sendMessage(messageFromType);
  }

  void configReceiveSendSuccessMessage(Message message) {
    Log.debug("收到发送成功消息 configReceiveSendSuccessMessage $message");
    Map<String, dynamic> decode = json.decode(message.content);
    SendSuccessModel model = SendSuccessModel.fromJson(decode);
    if (model.messageType == MessageType.READED_MESSAGE) {
      database.configMessageReaded(model);
    } else {
      database.configMessageSendSuccess(
          model, MessageSendStatus.STATUS_SEND_SUCCESS);
    }
  }

  void sendMessage(Message message) {
    Log.debug("发送消息 = $message");
    _messageQueue.addTask(() {
      return _sendMessage(message);
    });
  }

  Future<void> _sendMessage(Message message) async {
// 添加message
    database.addMessage(message);
    ByteBuf encode = _messageCodec.encode(message);
    return _socketManager.sendData(
        encode.readAllUint8List(), message.timestamp);
  }

  void connect() {
    if (!_socketManager.isConnected) {
      Log.info("开始建立长连接......");
      _socketManager.connect();
    }
  }

  void close() {
    if (_socketManager.isConnected) {
      _readByteBuf.clear();
      _socketManager.close();
    }
  }

// 告知服务器message已读
  void sendReadedMessage(Message message) {
    Message readMessage =
        MessageFactory.messageFromType(MessageType.READED_MESSAGE);
    readMessage.content = "${message.timestamp}";
    readMessage.fromId = UserManager.getInstance().uid();
    readMessage.fromEntity = MessageEntityType.USER;
    sendMessage(readMessage);
  }
}
