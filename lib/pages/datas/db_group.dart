import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/group.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupDB extends DbProtocol<Group> {
  late Box<Group> box;
  @override
  Future<void> install(String boxName) {
    Completer<void> completer = Completer<void>();
    Hive.openBox<Group>("group_$boxName").then((value) {
      box = value;
      Log.debug("初始化group_$boxName ，box = $box");
      completer.complete();
    });
    return completer.future;
  }

  @override
  void uninstall() {
    box.close();
  }

  @override
  void addItem(item) {
    box.put(item.groupId, item);
  }

  @override
  Future<int> deleteAllDatas() {
    return box.clear();
  }

  @override
  getItem(int id) {
    return box.get(id);
  }

  @override
  List<Group> getItems() {
    return box.values.toList();
  }

  @override
  void removeItem(item) {
    box.delete(item);
  }

  @override
  void updateItem(item) {
    box.put(item.groupId, item);
  }
}
