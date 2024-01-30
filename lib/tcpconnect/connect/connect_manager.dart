import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';

import 'package:desktop_im/tcpconnect/connect/byte_buffer.dart';
import 'package:desktop_im/tcpconnect/connect/message_codec.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';
import 'package:desktop_im/tcpconnect/socket/socket_manager.dart';
import 'package:desktop_im/tcpconnect/socket/socket_protocol.dart';
import 'package:flutter/foundation.dart';

class IMClient implements SocketListener {
  static IMClient? _instance;
  late SocketProtocol _socketManager;
  late MessageCodec _messageCodec;
  late ByteBuf _readByteBuf;
  @override
  SocketSuccessCallback? connectSuccess;
  @override
  SocketSendMessagesCallback? sendMessageSuccess;
  @override
  SocketReceiveCallback? receiveCallback;

  String host = "172.16.92.58";
  int port = 9999;
  static IMClient getInstance() {
    _instance ??= IMClient();
    return _instance!;
  }

  void init() {
    _readByteBuf = ByteBuf.allocator(size: 100);
    _messageCodec = MessageCodec();
    _socketManager = SocketManager(host, port);
    _socketManager.listener = _instance;
    connectSuccess = () {
      Log.debug("connect success!");
      //发送一个Login消息
      Message messageFromType =
          MessageFactory.messageFromType(MessageType.REQUEST_LOGIN);
      sendMessage(messageFromType);
    };
    sendMessageSuccess = (int timestamp) {
      Log.debug("send success! timestamp = $timestamp");
    };
    receiveCallback = (data) {
      _readByteBuf.writeUint8List(data);
      _readByteBuf.reset();
      if (_readByteBuf.couldReadableSize > 4) {
        // 说明长度至少在内
        int length = _readByteBuf.readInt();
        if (_readByteBuf.couldReadableSize >= length) {
          // 粘包
          ByteBuf asByteBuf = _readByteBuf.readUint8ListAsByteBuf(length);
          receiveData(asByteBuf.readAllUint8List());
          ByteBuf restByteBuf = _readByteBuf
              .readUint8ListAsByteBuf(_readByteBuf.couldReadableSize);
          _readByteBuf.clear();
          _readByteBuf.writeUint8List(restByteBuf.readAllUint8List());
        } else {
          // 半包
        }
      }
    };
  }

  void receiveData(Uint8List aData) {
    Message? message = _messageCodec.decode(aData);
    Log.debug("message = $message");
    if (message == null) {
      return;
    }
    switch (message.messageType) {
      case MessageType.TEXT:
        break;
      case MessageType.REQUEST_LOGIN:
        Log.debug(message.content);
        break;
      default:
    }
  }

  void sendMessage(Message message) {
    ByteBuf encode = _messageCodec.encode(message);
    _socketManager.sendData(encode.readAllUint8List(), message.timestamp);
  }

  void connect() {
    _socketManager.connect();
  }

  void close() {
    _readByteBuf.clear();
    _socketManager.close();
  }
}
