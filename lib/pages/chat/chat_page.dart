import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/notification/notification_helper.dart';
import 'package:desktop_im/notification/notification_service.dart';
import 'package:desktop_im/pages/chat/chat_user_item.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    implements
        IMDatabaseListener,
        NotificationHelperListener,
        IMClientListener {
  @override
  DatabaseCompleteCallback? completeCallback;

  @override
  DatabaseCompleteCallback? dataChangeCallback;

  @override
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  List<User> chatUsers = [];
  IMDatabase database = IMDatabase();

  @override
  void dispose() {
    database.removeListener(this);
    IMClient().removeListener(this);
    NotificationHelper().listener = null;
    super.dispose();
  }

  _ChatPageState() {
    database.addListener(this);
    IMClient().addListener(this);
    NotificationHelper().listener = this;
    completeCallback ??= () {
      chatUsers.addAll(database.getChatUsers());
      // Log.debug("chatUsers = $chatUsers");
      setState(() {});
    };
    dataChangeCallback ??= () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          chatUsers = [];
          chatUsers.addAll(database.getChatUsers());
          // Log.debug("chatUsers = $chatUsers");
          setState(() {});
        });
      });
    };

    connectSuccessCallback ??= (success) {
      Log.debug("连接成功？$success");
      if (success) {
        _showConnectStatus = false;
      } else {
        Log.debug("content");
        _showConnectStatus = true;
      }
    };
  }
  static bool _showConnectStatus = true;

  @override
  void initState() {
    super.initState();
    Log.debug("chat page init state");
    NotificationHelper().clearNotification();
    if (chatUsers.isEmpty && database.dbHasInstalled) {
      chatUsers.addAll(database.getChatUsers());
      setState(() {});
    }
    clickCallback = (user) {
      Routers().openRouter("/message", {"user": user}, context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return pagePadding(
      ListView.builder(
        itemCount: _showConnectStatus ? chatUsers.length + 1 : chatUsers.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 && _showConnectStatus) {
            return GestureDetector(
              onTap: () {
                reconnectSocket();
              },
              child: Container(
                color: Colors.red,
                child: Center(
                  child: itemPadding(Text(
                    "<-- ${S.current.retry_connecting} -- >",
                    style:
                        const TextStyle(color: kWhiteBackColor, fontSize: 16),
                  )),
                ),
              ),
            );
          }
          int userIndex = _showConnectStatus ? index - 1 : index;
          User user = chatUsers[userIndex];
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

  @override
  DatabaseAddReadableMessage? addReadableCallback;

  @override
  NotificationClickCallback? clickCallback;

  @override
  IMClientConnectSuccessCallback? connectSuccessCallback;

  @override
  IMClientReceiveMessageCallback? messageCallback;

  @override
  IMClientTransparentCallback? transparentCallback;

  @override
  IMClientUnReadedMessageCallback? unreadMessageCallback;

  void reconnectSocket() {
    IMClient().connect();
  }
}
