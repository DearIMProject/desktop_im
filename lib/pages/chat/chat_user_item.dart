import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/utils/time_utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatUserItem extends StatefulWidget {
  User? user;
  Message? lastMessage;
  int? unreadNumber = 0;
  ChatUserItem({super.key, this.user, this.lastMessage, this.unreadNumber});

  @override
  State<ChatUserItem> createState() => _ChatUserItemState();
}

class _ChatUserItemState extends State<ChatUserItem> {
  IMDatabase database = IMDatabase.getInstance();
  List<Widget> children() {
    List<Widget> children = [];

    children.add(Badge(
      isLabelVisible: widget.unreadNumber != 0,
      label: Text("${widget.unreadNumber}"),
      child: radiusBorder(networkImage(widget.user!.icon, 40, 40)),
    ));
    children.add(widthSpaceSizeBox);
    List<Widget> columnChildren = [];
    columnChildren.add(littleTitleFontText(kTitleColor, widget.user!.username));

    if (widget.lastMessage != null) {
      columnChildren.add(
          contentOverflowFontText(kDisableColor, widget.lastMessage!.content));
    }
    children.add(Expanded(
        flex: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        )));
    if (widget.lastMessage != null) {
      children.add(const Spacer(
        flex: 1,
      ));
      children.add(contentFontText(
          kDisableColor, getTime(widget.lastMessage!.timestamp)));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.user != null, "user is null!");
    return Container(
      color: kWhiteBackColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          itemSpaceHeightSizeBox,
          Row(
            children: children(),
          ),
          itemSpaceHeightSizeBox,
          const Divider(
            color: kLineColor,
          )
        ],
      ),
    );
  }
}
