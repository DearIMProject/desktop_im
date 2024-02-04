import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/utils/time_utils.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class ChatUserItem extends StatefulWidget {
  User? user;
  Message? lastMessage;
  ChatUserItem({super.key, this.user, this.lastMessage});

  @override
  State<ChatUserItem> createState() => _ChatUserItemState();
}

class _ChatUserItemState extends State<ChatUserItem> {
  List<Widget> children() {
    List<Widget> children = [];
    children.add(radiusBorder(networkImage(widget.user!.icon, 40, 40)));
    children.add(widthSpaceSizeBox);
    List<Widget> columnChildren = [];
    columnChildren.add(littleTitleFontText(kTitleColor, widget.user!.username));

    if (widget.lastMessage != null) {
      columnChildren
          .add(contentFontText(kDisableColor, widget.lastMessage!.content));
    }
    children.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    ));
    if (widget.lastMessage != null) {
      children.add(const Spacer());
      children.add(contentFontText(
          kDisableColor, getTime(widget.lastMessage!.timestamp)));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.user != null, "user is null!");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        itemSpaceHeightSizeBox,
        Row(
          children: children(),
        ),
        itemSpaceHeightSizeBox,
      ],
    );
  }
}
