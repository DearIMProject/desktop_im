import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/tcpconnect/socket/socket_protocol.dart';

class SocketManager implements SocketProtocol {
  // static SocketManager? _instance;
  late Socket _socket;
  @override
  SocketListener? listener;
  late String host;
  late int port;
  bool isConnected = false;

  SocketManager(this.host, this.port);

  // 建立socket连接
  @override
  Future<void> connect() async {
    _socket = await Socket.connect(host, port);
    Log.debug(
        'Connected to: ${_socket.remoteAddress.address}:${_socket.remotePort}');
    if (_socket.remoteAddress.host.isNotEmpty) {
      isConnected = true;
      if (listener != null && listener!.connectSuccess != null) {
        listener!.connectSuccess!();
      }
    }
    _socket.listen(
      (event) {
        if (listener != null && listener!.receiveCallback != null) {
          listener!.receiveCallback!(event);
          Log.debug('Received: $event');
        }
      },
      onError: (error) {
        Log.debug('Error: $error');
        isConnected = false;
        _socket.destroy();
      },
      onDone: () {
        Log.debug('Connection closed');
        isConnected = false;
        _socket.destroy();
      },
    );
  }

  @override
  void close() {
    try {
      _socket.close();
    } catch (e) {
      Log.warn("error = $e");
    }
  }

  @override
  void sendData(Uint8List data, int timestamp) {
    _socket.add(data);
    _socket.flush();
    if (listener != null && listener!.sendMessageSuccess != null) {
      listener!.sendMessageSuccess!(timestamp);
    }
  }
}
