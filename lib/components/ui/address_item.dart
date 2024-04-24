import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/models/message/chat_entity.dart';
import 'package:flutter/material.dart';

class AddressChatEntityItem extends StatefulWidget {
  final ChatEntity? user;
  const AddressChatEntityItem({super.key, this.user});

  @override
  State<AddressChatEntityItem> createState() => _AddressChatEntityItemState();
}

class _AddressChatEntityItemState extends State<AddressChatEntityItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          radiusBorder(networkImage(widget.user!.getIconUrl(), 40, 40)),
          itemSpaceWidthSizeBox,
          subTitleFontText(kTitleColor, widget.user!.getName()),
        ],
      ),
    );
  }
}
