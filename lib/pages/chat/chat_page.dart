import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/chat/chat_user_item.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<User> chatUsers = [];
  IMDatabase database = IMDatabase.getInstance();
  @override
  void initState() {
    super.initState();
    Log.debug("chat page init state");
    if (chatUsers.isEmpty) {
      chatUsers.addAll(database.getChatUsers());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return pagePadding(
      ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (BuildContext context, int index) {
          User user = chatUsers[index];
          return GestureDetector(
            onTap: () {
              Routers().openRouter("/message", {"user": user}, context);
            },
            child: ChatUserItem(
              user: user,
              lastMessage: database.getLastMessage(user.userId),
            ),
          );
        },
      ),
    );
  }
}
