import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:hive/hive.dart';

/// 用于存放通讯录的信息
class UserDB implements DbProtocol<User> {
  late Box<User> box;
  @override
  Future<void> install(String boxName) async {
    Completer<void> completer = Completer();
    Hive.openBox<User>("user_$boxName").then((value) {
      box = value;
      completer.complete();
      Log.info("初始化 user_$boxName box =$box");
    });
    return completer.future;
  }

  @override
  void uninstall() {
    box.close();
  }

  @override
  void addItem(item) {
    box.put(item.userId, item);
  }

  @override
  void removeItem(item) {
    box.delete(item.userId);
  }

  @override
  void updateItem(item) {
    box.put(item.userId, item);
  }

  @override
  getItem(int id) {
    return box.get(id);
  }

  @override
  List<User> getItems() {
    return box.values.toList();
  }

  @override
  Future<int> deleteAllDatas() {
    return box.clear();
  }
}
