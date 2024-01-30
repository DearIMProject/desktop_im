import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';

class Log {
  static const _escape = '\x1b[';
  static const _resetColor = '${_escape}0m'; // 重置颜色，确保之后的文本不受影响

  static const _red = '${_escape}31m';
  static const _green = '${_escape}32m';
  static const _yellow = '${_escape}33m';
  static const _blue = '${_escape}34m';
  // static const _magenta = '${_escape}35m';
  // static const _cyan = '${_escape}36m';
  Log.debug(String content) {
    if (kDebugMode) {
      Logger().d('$_green$content$_resetColor');
    }
  }
  Log.info(String content) {
    if (kDebugMode) {
      Logger().d('$_blue$content$_resetColor');
    }
  }
  Log.warn(String content) {
    if (kDebugMode) {
      Logger().d('$_yellow$content$_resetColor');
    }
  }
  Log.error(String content) {
    if (kDebugMode) {
      Logger().d('$_red$content$_resetColor');
    }
  }
}
