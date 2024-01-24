import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef RouterCallback = void Function(
    Map<String, dynamic> params, BuildContext context);

class _RouterModel {
  late String router;
  late RouterCallback callback;
}

class Routers {
  final Map<String, Widget Function(BuildContext)> _map = {};
  final Map<String, _RouterModel> _routers = {};
  Routers._privateConstructor();
  static final Routers _instance = Routers._privateConstructor();
  factory Routers() {
    return _instance;
  }
  Map<String, Widget Function(BuildContext)> routers() {
    return _map;
  }

  void addPageRouter(
      String host, Widget Function(BuildContext) widget, BuildContext context) {
    if (!_map.containsKey(host)) {
      _map[host] = widget;

      var routerModel = _RouterModel();
      routerModel.router = host;
      routerModel.callback =
          (Map<String, dynamic> params, BuildContext buildcontext) {
        Navigator.push(buildcontext, MaterialPageRoute(builder: widget));
      };
      _routers[host] = routerModel;
    }
    if (kDebugMode) {
      print("map = $_map");
    }
  }

  /// 注销router
  void unregisterRouter(String host) {
    if (_map.containsKey(host)) {
      _map.remove(host);
    }
    if (_routers.containsKey(host)) {
      _routers.remove(host);
    }
  }

  /// 注册router
  void registerRouter(String host, RouterCallback callback) {
    if (_routers.containsKey(host)) {
      return;
    }
    var routerModel = _RouterModel();
    routerModel.router = host;
    routerModel.callback = callback;
    _routers[host] = routerModel;
  }

  /// 打开router
  void openRouter(
      String host, Map<String, dynamic> params, BuildContext context) {
    if (!_routers.containsKey(host)) {
      return;
    }
    _RouterModel routerModel = _routers[host]!;
    routerModel.callback(params, context);
  }
}
