import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/chat_entity.dart';
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
  List<ChatEntity> chatEntitys = [];
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
        chatEntitys = [];
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
    List<ChatEntity> aChatEntitys = database.getChatEntitys();
    for (ChatEntity chatEntity in aChatEntitys) {
      bool hasMessage = database.hasContextMessage(chatEntity.getKey());
      if (hasMessage) {
        chatEntitys.add(chatEntity);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Log.debug("chat page init state");
    NotificationHelper().clearNotification();
    if (chatEntitys.isEmpty && database.dbHasInstalled) {
      refreshDatas();
    }
    clickCallback = (user) {
      Map<String, dynamic> map = {"user": user, "type": MessageListType.USER};
      Routers().openRouter("/message", map, context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return pagePadding(
      ListView.builder(
        itemCount:
            _showConnectStatus ? chatEntitys.length + 1 : chatEntitys.length,
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
          ChatEntity entity = chatEntitys[userIndex];
          return GestureDetector(
            onTap: () {
              Routers().openRouter("/message",
                  {"user": entity, "type": MessageListType.USER}, context);
            },
            child: ChatEntityItem(
              entity: entity,
              lastMessage: database.getLastMessage(entity.getKey()),
              unreadNumber: database.unreadNumber(entity.getKey()),
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
