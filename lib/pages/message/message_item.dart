import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';

import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';

import 'package:flutter/material.dart';

const double _iconWidth = 40;

// ignore: must_be_immutable
class MesssageItemView extends StatefulWidget {
  Message message;
  String? icon;
  MesssageItemView({super.key, this.icon, required this.message});

  @override
  State<MesssageItemView> createState() => _MesssageItemViewState();
}

class _MesssageItemViewState extends State<MesssageItemView> {
  IMDatabase database = IMDatabase.getInstance();
  IMClient client = IMClient.getInstance();
  bool isSendToSelf() {
    return widget.message.fromId == widget.message.toId;
  }

  Widget circleView() {
    return const SizedBox(
      height: 30,
      child: Column(
        children: [
          SizedBox(
            height: 7,
          ),
          SizedBox(
            // color: Colors.red,
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              color: kThemeColor,
              strokeWidth: 2,
            ),
          ),
          SizedBox(
            height: 7,
          ),
        ],
      ),
    );
  }

  Widget notSendView() {
    return const Icon(
      Icons.error,
      color: kWarningColor,
      size: 20,
    );
  }

  final double _textRadius = 8;
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
            borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(widget.message.isOwner ? _textRadius : 0),
                topRight:
                    Radius.circular(!widget.message.isOwner ? _textRadius : 0),
                bottomLeft: Radius.circular(_textRadius),
                bottomRight: Radius.circular(_textRadius)),
            child: Container(
              color: kThemeColor,
              child: roundItemPadding(
                  littleTitleFontText(kMessageColor, widget.message.content)),
            ),
          ),
          200),
      itemSpaceWidthSizeBox,
      Visibility(
        visible:
            (widget.message.sendStatue == MessageSendStatus.STATUS_SEND_ING &&
                !isSendToSelf()),
        child: circleView(),
      ),
      Visibility(
        visible:
            widget.message.sendStatue == MessageSendStatus.STATUS_SEND_FAILURE,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
          child: notSendView(),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return itemPadding(Row(
      mainAxisAlignment: widget.message.isOwner
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          !widget.message.isOwner ? children() : children().reversed.toList(),
    ));
  }
}
