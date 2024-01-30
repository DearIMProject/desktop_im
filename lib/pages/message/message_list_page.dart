import 'dart:math';

import 'package:desktop_im/components/common/common_theme.dart';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/message/message.dart';

import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/base_page.dart';
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
  List<Message> messages = [];
  @override
  void initState() {
    super.initState();
    chatUser = widget.params?["user"];
    Log.info("chatUser = $chatUser");
    if (messages.isEmpty) {
      //TODO: wmy 获取属于chatUser的message
      for (var i = 0; i < 10; i++) {
        Message message = Message();

        if (Random().nextInt(10) ~/ 2 == 0) {
          message.fromId = UserManager.getInstance().uid();
        } else {
          message.fromId = 18;
        }
        message.content = "一段文字一段文字 $i ${message.isOwner}";
        messages.add(message);
      }
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
                icon:
                    chatUser?.icon //TODO: wmy 这里的icon不对，需要根据message的fromId来决定,
                );
          },
        ),
      ),
    );
  }
}
