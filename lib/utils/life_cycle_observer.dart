import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:flutter/material.dart';

class LifeCycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 前台。判断是否还连接着
      if (!IMClient().isConencted) {
        IMClient().connect();
      }
    }
    if (state == AppLifecycleState.paused) {
      // 后台
    }
  }
}
