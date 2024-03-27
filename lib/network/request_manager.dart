import 'package:desktop_im/config.dart';

enum NetworkEnvironment {
  online,
  daily,
}

class RequestManager {
  NetworkEnvironment networkenv = NetworkEnvironment.daily;
  String _hostName = "";
  RequestManager._privateConstructor();

  static final RequestManager _instance = RequestManager._privateConstructor();

  factory RequestManager() {
    _instance._hostName = "http://$HOST:8888/";

    return _instance;
  }

  String hostName() {
    return _hostName;
  }
}
