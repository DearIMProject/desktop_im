import 'package:desktop_im/components/common/common_theme.dart';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';

import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/message/message_item.dart';
import 'package:desktop_im/user/user_manager.dart';

import 'package:flutter/material.dart';

class MessageListPage extends BasePage {
  const MessageListPage({super.key, super.params});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  User? chatUser;
  User? user = UserManager.getInstance().user;
  List<Message> messages = [];
  IMDatabase database = IMDatabase.getInstance();
  @override
  void initState() {
    super.initState();
    if (messages.isNotEmpty) {
      return;
    }
    chatUser = widget.params?["user"];
    if (chatUser == null) {
      throw Exception("chatUser is null");
    }
    if (user == null) {
      throw Exception("user is null");
    }
    Log.info("chatUser = $chatUser");
    if (messages.isEmpty) {
      messages.addAll(database.getMessages(chatUser!.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    Log.debug("chatUser = $chatUser");
    return Scaffold(
      appBar: AppBar(
        title: titleFontText(kTitleColor, chatUser?.username ?? ""),
      ),
      body: pagePadding(
        ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            Message message = messages[index];
            return MesssageItemView(
                message: message,
                icon: message.isOwner ? user!.icon : chatUser!.icon);
          },
        ),
      ),
    );
  }
}
