import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/tcpconnect/socket/socket_protocol.dart';
import 'package:desktop_im/utils/uint8list_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SocketManager implements SocketProtocol {
  // static SocketManager? _instance;
  Socket? _socket;
  @override
  SocketListener? listener;
  late String host;
  late int port;
  bool _isConnected = false;
  @override
  bool get isConnected => _isConnected;

  SocketManager(this.host, this.port) {
    checkConnection();
  }

  void checkConnection() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event.contains(ConnectivityResult.mobile) ||
          event.contains(ConnectivityResult.wifi)) {
      } else {
        _isConnected = false;
      }
      if (listener != null && listener!.connectSuccess != null) {
        listener!.connectSuccess!(_isConnected);
      }
    });
  }

  // 建立socket连接
  @override
  Future<void> connect() async {
    _socket = await Socket.connect(host, port);
    Log.debug(
        'Connected to: ${_socket!.remoteAddress.address}:${_socket!.remotePort}');
    if (_socket!.remoteAddress.host.isNotEmpty) {
      _isConnected = true;
      if (listener != null && listener!.connectSuccess != null) {
        listener!.connectSuccess!(true);
      }
    }
    _socket!.listen(
      (event) {
        if (listener != null && listener!.receiveCallback != null) {
          listener!.receiveCallback!(event);
          // Log.debug('Received: $event');
        }
      },
      onError: (error) {
        Log.debug('Error: $error');
        closeConnect();
        if (listener != null && listener!.connectSuccess != null) {
          listener!.connectSuccess!(_isConnected);
        }
      },
      onDone: () {
        Log.debug('Connection closed');
        closeConnect();
        if (listener != null && listener!.connectSuccess != null) {
          listener!.connectSuccess!(_isConnected);
        }
      },
    );
  }

  void closeConnect() {
    _isConnected = false;
    close();
    if (listener != null && listener!.connectSuccess != null) {
      listener!.connectSuccess!(_isConnected);
    }
  }

  @override
  void close() {
    if (_socket == null) return;
    try {
      _socket!.close();
    } catch (e) {
      Log.warn("error = $e");
    }
  }

  @override
  Future<void> sendData(Uint8List data, int timestamp) async {
    Completer completer = Completer();
    String dataStr = Uint8ListUtils.uint8ListToHex(data);
    Log.info("发送一个数据段：$dataStr");
    _socket!.add(data);
    _socket!.flush().then((value) => completer.complete());
    if (listener != null && listener!.sendMessageSuccess != null) {
      listener!.sendMessageSuccess!(timestamp);
    }
    return completer.future;
  }
}
