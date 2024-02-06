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

class _ChatPageState extends State<ChatPage> implements IMDatabaseListener {
  @override
  DatabaseCompleteCallback? completeCallback;

  @override
  DatabaseCompleteCallback? dataChangeCallback;

  @override
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  List<User> chatUsers = [];
  IMDatabase database = IMDatabase.getInstance();

  _ChatPageState() {
    database.addListener(this);
    completeCallback = () {
      chatUsers.addAll(database.getChatUsers());
      Log.debug("chatUsers = $chatUsers");
      setState(() {});
    };
    dataChangeCallback = () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    };
  }

  @override
  void dispose() {
    database.removeListener(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Log.debug("chat page init state");
    if (chatUsers.isEmpty && database.dbHasInstalled) {
      chatUsers.addAll(database.getChatUsers());
      Log.debug("chatUsers = $chatUsers");
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
              unreadNumber: database.unreadNumber(user.userId),
            ),
          );
        },
      ),
    );
  }
}
