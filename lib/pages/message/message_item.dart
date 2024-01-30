import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/models/message/message.dart';

import 'package:flutter/material.dart';

const double _iconWidth = 30;

// ignore: must_be_immutable
class MesssageItemView extends StatefulWidget {
  Message message;
  String? icon;

  MesssageItemView({super.key, this.icon, required this.message});

  @override
  State<MesssageItemView> createState() => _MesssageItemViewState();
}

class _MesssageItemViewState extends State<MesssageItemView> {
  List<Widget> children() {
    return [
      widget.icon != null
          ? radiusCustomBorder(
              networkImage(widget.icon ?? "", _iconWidth, _iconWidth),
              _iconWidth * 0.5)
          : Image.asset(
              "/assets/images/icon.png",
              width: _iconWidth,
              height: _iconWidth,
            ),
      itemSpaceWidthSizeBox,
      maxWidthWidget(
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                // bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            child: Container(
              color: kThemeColor,
              child: roundItemPadding(
                  littleTitleFontText(kMessageColor, widget.message.content)),
            ),
          ),
          200)

      // ConstrainedBox(constraints: BoxConstraints(minWidth: 100)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return itemPadding(Row(
      mainAxisAlignment: widget.message.isOwner
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children:
          widget.message.isOwner ? children() : children().reversed.toList(),
    ));
  }
}
