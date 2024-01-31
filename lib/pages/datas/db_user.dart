import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:hive/hive.dart';

class DBUser implements DbProtocol {
  late Box<User> box;
  @override
  Future<void> install(String boxName) async {
    box = await Hive.openBox("user_$boxName");
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
}
