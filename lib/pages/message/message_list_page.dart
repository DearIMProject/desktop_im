import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MessageListPage extends BasePage {
  const MessageListPage({super.key, super.params});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  User? chatUser;
  @override
  void initState() {
    super.initState();
    chatUser = widget.params?["user"];
    if (kDebugMode) {
      print("chatUser = $chatUser");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text("message = $chatUser");
  }
}
