// import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_toastr/flutter_toastr.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class ToastShowUtils {
  ///
  /// 显示toast msg
  ///
  ToastShowUtils.show(String msg, BuildContext context) {
    // if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_msg)));
    // } else {
    //   Fluttertoast.showToast(msg: _msg);
    // }

    // FlutterToastr
    FlutterToastr.show(msg, context);
  }
}
