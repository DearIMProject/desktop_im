import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/chat_entity.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/notification/notification_helper.dart';
import 'package:desktop_im/notification/notification_service.dart';
import 'package:desktop_im/pages/chat/chat_user_item.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/message/message_list_type.dart';
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
  List<ChatEntity> chatUsers = [];
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
      refreshDatas();
    };
    dataChangeCallback ??= () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        chatUsers = [];
        refreshDatas();
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

  void refreshDatas() {
    List<ChatEntity> aChatUsers = database.getChatUsers();
    for (ChatEntity chatUser in aChatUsers) {
      bool hasMessage = database.hasContextMessage(chatUser.getKey());
      if (hasMessage) {
        chatUsers.add(chatUser);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Log.debug("chat page init state");
    NotificationHelper().clearNotification();
    if (chatUsers.isEmpty && database.dbHasInstalled) {
      refreshDatas();
    }
    clickCallback = (user) {
      Routers().openRouter(
          "/message", {"user": user, "type": MessageListType.USER}, context);
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
          ChatEntity entity = chatUsers[userIndex];
          return GestureDetector(
            onTap: () {
              Routers().openRouter("/message", {"user": entity}, context);
            },
            child: ChatEntityItem(
              user: entity,
              lastMessage: database.getLastMessage(entity.userId),
              unreadNumber: database.unreadNumber(entity.userId),
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
