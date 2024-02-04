import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:hive/hive.dart';

class UserDB implements DbProtocol {
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
    // TODO: implement addItem
  }

  @override
  void removeItem(item) {
    // TODO: implement removeItem
  }

  @override
  void updateItem(item) {
    // TODO: implement updateItem
  }

  Future<int> deleteAll() {
    return box.clear();
  }

  /// 根据userId获取user
  User? getUser(int chatUserId) {
    return box.get(chatUserId);
  }

  /// 添加用户
  void addUser(User user) {
    box.put(user.userId, user);
  }

  List<User> getUsers() {
    return box.values.toList();
  }
}
