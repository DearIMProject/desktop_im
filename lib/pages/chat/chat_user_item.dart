import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/models/message/chat_entity.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/utils/time_utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatEntityItem extends StatefulWidget {
  ChatEntity? entity;
  Message? lastMessage;
  int? unreadNumber = 0;
  ChatEntityItem({super.key, this.entity, this.lastMessage, this.unreadNumber});

  @override
  State<ChatEntityItem> createState() => _ChatEntityItemState();
}

class _ChatEntityItemState extends State<ChatEntityItem> {
  IMDatabase database = IMDatabase();
  List<Widget> children() {
    List<Widget> children = [];

    children.add(Badge(
      isLabelVisible: widget.unreadNumber != 0,
      label: Text("${widget.unreadNumber}"),
      child: radiusBorder(networkImage(widget.entity!.getIconUrl(), 40, 40)),
    ));
    children.add(widthSpaceSizeBox);
    List<Widget> columnChildren = [];
    columnChildren
        .add(littleTitleFontText(kTitleColor, widget.entity!.getName()));

    if (widget.lastMessage != null) {
      String content = widget.lastMessage!.content;
      if (widget.lastMessage!.messageType == MessageType.PICTURE) {
        content = S.current.chat_user_image;
      }
      columnChildren.add(contentOverflowFontText(kDisableColor, content));
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
    assert(widget.entity != null, "user is null!");
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
