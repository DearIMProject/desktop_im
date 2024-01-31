import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/pages/datas/db_protocol.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:hive/hive.dart';

class DBMessage implements DbProtocol {
  late Box<List<Message>> box;

  @override
  Future<void> install(String boxName) async {
    box = await Hive.openBox<List<Message>>("message_$boxName");
  }

  @override
  void uninstall() {
    box.close();
  }

  int getMUserId(Message message) {
    int mUserId = message.fromId;
    if (mUserId == UserManager.getInstance().uid()) {
      mUserId = message.toId;
    }
    return mUserId;
  }

  @override
  void addItem(item) {
    if (item is Message) {
      int mUserId = getMUserId(item);
      List<Message>? messages = getMessages(item);
      messages ??= [];
      messages.add(item);
      box.put(mUserId, messages);
    }
  }

  @override
  void removeItem(item) {
    int mUserId = getMUserId(item);
    List<Message>? messages = getMessages(item);
    if (messages != null && messages.contains(item)) {
      messages.remove(item);
      box.put(mUserId, messages);
    }
  }

  @override
  void updateItem(item) {
    getMessages(item);
  }

  List<Message>? getMessages(item) {
    Message message = item;
    int mUserId = getMUserId(message);
    List<Message>? messages = box.get(mUserId);
    return messages;
  }

  int maxTimestamp() {
    List<List<Message>> list = box.values.toList();
    if (list.isEmpty) {
      return 0;
    }
    List<Message> result = [];
    for (List<Message> messages in list) {
      result.addAll(messages);
    }
    if (result.isEmpty) {
      return 0;
    }
    Message maxTimestamp = result.reduce((Message current, Message next) =>
        current.timestamp > next.timestamp ? current : next);
    return maxTimestamp.timestamp;
  }
}
