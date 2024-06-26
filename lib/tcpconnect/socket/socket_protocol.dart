import 'dart:typed_data';

abstract class SocketListener {
  SocketSuccessCallback? connectSuccess;
  SocketSendMessagesCallback? sendMessageSuccess;
  SocketReceiveCallback? receiveCallback;
}

typedef SocketSuccessCallback = void Function(bool success);
typedef SocketSendMessagesCallback = void Function(int timestamp);
typedef SocketReceiveCallback = void Function(Uint8List? data);

abstract class SocketProtocol {
  bool get isConnected;
  SocketListener? listener;
  void connect();
  void close();
  Future<void> sendData(Uint8List data, int timestamp);
}
