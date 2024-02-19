import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/message_input.dart';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';

import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/message/message_item.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';
import 'package:desktop_im/user/user_manager.dart';

import 'package:flutter/material.dart';

class MessageListPage extends BasePage {
  const MessageListPage({super.key, super.params});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage>
    implements IMDatabaseListener {
  User? chatUser;
  User? user = UserManager.getInstance().user;
  List<Message> messages = [];
  IMDatabase database = IMDatabase.getInstance();
  IMClient client = IMClient.getInstance();
  @override
  DatabaseCompleteCallback? completeCallback;

  @override
  DatabaseCompleteCallback? dataChangeCallback;

  @override
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    database.removeListener(this);
    _scrollController.dispose();
    super.dispose();
  }

  _MessageListPageState() {
    database.addListener(this);
  }
// 滚动到底部
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    }
  }

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
    if (messages.isEmpty) {
      messages.addAll(database.getChatMessages(chatUser!.userId));
      configSendReadMessage();
    }
    dataChangeCallback ??= () {
      messages = [];
      messages.addAll(database.getChatMessages(chatUser!.userId));
      configSendReadMessage();
      Log.debug("收到消息发生了变化 $messages");
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          setState(() {});
        },
      );
    };

    // 滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  bool hasSend = false;
  void configSendReadMessage() {
    if (hasSend) {
      return;
    }
    hasSend = true;
    for (Message message in messages) {
      if (!message.isOwner) {
        if (message.status == MessageStatus.STATUS_NOT_SEND_UNREAD) {
          Log.debug("xiaoxi $message");
          client.sendReadedMessage(message);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Log.debug("chatUser = $chatUser");

    return Scaffold(
      appBar: AppBar(
        title: titleFontText(kTitleColor, chatUser?.username ?? ""),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: pagePadding(
              ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  Message message = messages[index];
                  return MesssageItemView(
                      message: message,
                      icon: message.isOwner ? user!.icon : chatUser!.icon);
                },
              ),
            ),
          ),
          MessageInputView(
            sendCallback: (text) {
              if (text.isNotEmpty) {
                Message message =
                    MessageFactory.messageFromType(MessageType.TEXT);
                message.fromId = user!.userId;
                message.fromEntity = MessageEntityType.USER;
                message.toId = chatUser!.userId;
                message.toEntity = MessageEntityType.USER;
                message.content = text;
                client.sendMessage(message);
                messages.add(message);
                Log.debug("发送了一个消息：$message");
                setState(() {});
                _scrollToBottom();
              }
            },
          ),
        ],
      ),
    );
  }
}
