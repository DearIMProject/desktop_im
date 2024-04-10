import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectUserItem extends StatefulWidget {
  User? user;

  int? unreadNumber = 0;
  SelectUserItem({
    super.key,
    this.user,
    this.unreadNumber,
  });

  @override
  State<SelectUserItem> createState() => _SelectUserItemState();
}

class _SelectUserItemState extends State<SelectUserItem> {
  IMDatabase database = IMDatabase();
  List<Widget> children() {
    List<Widget> children = [];
    children.add(Icon(
      widget.user!.isSelected
          ? Icons.check_circle
          : Icons.radio_button_unchecked,
      color: kThemeColor,
    ));
    children.add(widthSpaceSizeBox);
    children.add(radiusBorder(networkImage(widget.user!.icon, 40, 40)));
    children.add(widthSpaceSizeBox);
    List<Widget> columnChildren = [];
    columnChildren.add(littleTitleFontText(kTitleColor, widget.user!.username));

    children.add(Expanded(
        flex: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        )));

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
