import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:desktop_im/config.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_json_model.dart';
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
typedef IMClientConnectSuccessCallback = void Function(bool success);
typedef IMClientTransparentCallback = void Function(Message message);

// ignore: constant_identifier_names
const String MAGIC_NUMBER = "891013";

abstract class IMClientListener {
  /// 收到消息回调
  IMClientReceiveMessageCallback? messageCallback;

  /// 未读消息回调
  IMClientUnReadedMessageCallback? unreadMessageCallback;

  /// 连接成功
  IMClientConnectSuccessCallback? connectSuccessCallback;

  /// 透传信息
  IMClientTransparentCallback? transparentCallback;
}

class IMClient implements SocketListener {
  late SocketProtocol _socketManager;
  late MessageCodec _messageCodec;
  late ByteBuf _readByteBuf;
  final String _host = HOST;
  final int _port = 9999;

  final int _second = 30;
  Timer? _timer;

  bool get isConencted {
    return _socketManager.isConnected;
  }

  IMDatabase database = IMDatabase();
  @override
  SocketSuccessCallback? connectSuccess;
  @override
  SocketSendMessagesCallback? sendMessageSuccess;
  @override
  SocketReceiveCallback? receiveCallback;

  List<IMClientListener> listeners = [];
  final MessageQueue _messageQueue = MessageQueue();

  /// 添加监听
  void addListener(IMClientListener listener) {
    if (listeners.contains(listener)) {
      return;
    }
    listeners.add(listener);
  }

  /// 删除监听
  void removeListener(IMClientListener listener) {
    if (listeners.contains(listener)) {
      listeners.remove(listener);
    }
  }

  static final IMClient _instance = IMClient._internal();

  factory IMClient() {
    return _instance;
  }
  void checkConnection() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event.contains(ConnectivityResult.mobile) ||
          event.contains(ConnectivityResult.wifi)) {
        // 有网络了，可以进行重连了
        Log.debug("有网络了，可以进行重连了");
        if (!_socketManager.isConnected &&
            UserManager().userToken().isNotEmpty) {
          retryConnectSocket();
        }
      }
    });
  }

  IMClient._internal();

  void dispose() {
    // _messageQueue.dispose();
  }

  void init() {
    checkConnection();
    _readByteBuf = ByteBuf.allocator(size: 100);
    _messageCodec = MessageCodec();
    _socketManager = SocketManager(_host, _port);
    _socketManager.listener = _instance;
    connectSuccess ??= (isConected) {
      if (!isConencted) {
        Log.debug("断连了");
        endTimer();
        _socketManager.close();
        if (UserManager().userToken().isNotEmpty) {
          retryConnectSocket();
        }
        return;
      }
      Log.info("成功建立长连接！");
      if (listeners.isNotEmpty) {
        for (IMClientListener listener in listeners) {
          if (listener.connectSuccessCallback != null) {
            listener.connectSuccessCallback!(isConected);
          }
        }
      } else {}
    };
    sendMessageSuccess = (int timestamp) {
      Log.info("消息发送成功！ timestamp = $timestamp");
    };
    // 底层数据包返回，处理粘包半包
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
          _receiveData(asByteBuf.readAllUint8List());
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

  retryConnectSocket() {
    connect();
  }

  // ignore: non_constant_identifier_names
  final int _MAX_LOST_HEART_BEAT_COUNT = 5;
  int _currentSendHeartBeatCount = 0;

  /// 发送登录成功信息
  void sendRequestLoginMessage() {
    _sendRequestLoginMessge();
  }

  void sendHeartBeatMessage() {
    Log.debug("发送一个心跳包");
    _currentSendHeartBeatCount++;
    if (_currentSendHeartBeatCount >= _MAX_LOST_HEART_BEAT_COUNT) {
      //TODO: wmy 重连；
      _socketManager.close();
      _socketManager.connect();
      return;
    }
    Message message = MessageFactory.messageFromType(MessageType.HEART_BEAT);
    message.fromId = UserManager().uid();
    message.fromEntity = MessageEntityType.USER;
    sendMessage(message);
    startTimer();
  }

  Future<void> _sendRequestLoginMessge() async {
    Message messageFromType =
        MessageFactory.messageFromType(MessageType.REQUEST_LOGIN);
    sendMessage(messageFromType);
  }

  /// 收到完成数据包
  void _receiveData(Uint8List aData) {
    startTimer();
    Message? message = _messageCodec.decode(aData);
    if (message == null) {
      return;
    }
    switch (message.messageType) {
      case MessageType.TEXT:
      case MessageType.PICTURE:
        _configReceiveTextMessage(message);
        break;
      case MessageType.REQUEST_LOGIN:
        _configReceiveRequestLoginMessage(message);
        break;
      case MessageType.SEND_SUCCESS_MESSAGE:
        _configReceiveSendSuccessMessage(message);
        break;
      case MessageType.HEART_BEAT:
        Log.debug("收到心跳包");
        _currentSendHeartBeatCount--;
        break;
      case MessageType.TRANSPARENT_MESSAGE:
        _configTransparentMessage(message);
        break;
      default:
    }
  }

  /// 处理收到的text消息
  void _configReceiveTextMessage(Message message) {
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

  /// 处理收到的登录成功消息
  void _configReceiveRequestLoginMessage(Message message) {
    Log.debug("收到登录消息 configReceiveRequestLoginMessage");

    if (message.content.contains(MAGIC_NUMBER)) {
      sendRequestOfflineMessage();
    } else {
      // 登录失败
      String token = UserManager().userToken();
      if (token.isNotEmpty) {
        _autologin(token);
      } else {
        NotificationStream().publish(kLogoutSuccessNotification);
      }
    }
  }

  /// 自动登录
  void _autologin(String token) {
    LoginService.autoLogin(token, Callback(
      successCallback: () {
        sendRequestLoginMessage();
      },
    ));
  }

  /// 发送离线消息
  void sendRequestOfflineMessage() {
    Log.debug("发送获取离线消息 sendRequestOfflineMessage");
    Message messageFromType =
        MessageFactory.messageFromType(MessageType.REQUEST_OFFLINE_MESSAGES);
    messageFromType.timestamp = database.getMaxTimestamp();
    Log.debug("timestamp = ${messageFromType.timestamp}");

    sendMessage(messageFromType);
  }

  void _configReceiveSendSuccessMessage(Message message) {
    Log.debug("收到发送成功消息 configReceiveSendSuccessMessage $message");
    Map<String, dynamic> decode = json.decode(message.content);
    SendJsonModel model = SendJsonModel.fromJson(decode);
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
    readMessage.fromId = UserManager().uid();
    readMessage.fromEntity = MessageEntityType.USER;
    sendMessage(readMessage);
  }

  void startTimer() {
    endTimer();
    // Log.debug("开始30s计时");
    _timer ??= Timer.periodic(Duration(seconds: _second), (timer) {
      sendHeartBeatMessage();
    });
  }

  void endTimer() {
    // Log.debug("结束30s计时");
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  /// 处理自定义透传消息
  void _configTransparentMessage(Message message) {
    Log.debug("收到一个透传消息");
    for (IMClientListener listener in listeners) {
      if (listener.transparentCallback != null) {
        listener.transparentCallback!(message);
      }
    }
  }
}
