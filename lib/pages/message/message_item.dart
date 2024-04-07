import 'package:desktop_im/components/common/common_dialog.dart';
import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/loading_image.dart';
import 'package:desktop_im/components/uikits/emoji/emoji_special_text_span_builder.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/fileBean.dart';

import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/utils/time_utils.dart';
import 'package:extended_text_field/extended_text_field.dart';

import 'package:flutter/material.dart';

const double _iconWidth = 40;

typedef DeleteCallback = void Function(Message message);

// ignore: must_be_immutable
class MesssageItemView extends StatefulWidget {
  Message message;
  String? icon;
  DeleteCallback? deleteCallback;
  MesssageItemView(
      {super.key, this.icon, required this.message, this.deleteCallback});

  @override
  State<MesssageItemView> createState() => _MesssageItemViewState();
}

class _MesssageItemViewState extends State<MesssageItemView> {
  IMDatabase database = IMDatabase();
  IMClient client = IMClient();
  bool hasSend = false;
  bool isSendToSelf() {
    return widget.message.fromId == widget.message.toId;
  }

  @override
  void initState() {
    super.initState();
    configSendReadMessage();
  }

  void configSendReadMessage() {
    if (hasSend) {
      return;
    }
    hasSend = true;
    if (!widget.message.isOwner) {
      // Log.debug("${widget.message.status}");
      if (widget.message.status == MessageStatus.STATUS_SUCCESS_UNREADED) {
        // Log.debug("消息 ${widget.message}");
        client.sendReadedMessage(widget.message);
      }
    }
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

  Widget readView() {
    return const Icon(
      Icons.check_circle,
      color: kSuccessColor,
      size: 20,
    );
  }

  Widget unReadView() {
    return const Icon(
      Icons.check_circle_outline,
      color: kDisableColor,
      size: 20,
    );
  }

  final double _textRadius = 8;
  List<Widget> children() {
    double imageWidth = 0;
    double imageHeight = 0;
    if (widget.message.imageFileBean != null) {
      Log.debug("${widget.message.imageFileBean}");
      imageWidth = 200.0;
      imageHeight = (widget.message.imageFileBean!.height *
          200.0 /
          widget.message.imageFileBean!.width);
      imageHeight = double.parse(imageHeight.toStringAsFixed(2));
      Log.debug("imageWidth = $imageWidth");
      Log.debug("imageHeight = $imageHeight");
    }

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
      Visibility(
        visible: widget.message.messageType == MessageType.TEXT,
        child: maxWidthWidget(
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(widget.message.isOwner ? _textRadius : 0),
                  topRight: Radius.circular(
                      !widget.message.isOwner ? _textRadius : 0),
                  bottomLeft: Radius.circular(_textRadius),
                  bottomRight: Radius.circular(_textRadius)),
              child: Container(
                color: kThemeColor,
                child: roundItemPadding(ExtendedSelectableText(
                  widget.message.content,
                  style: const TextStyle(
                    color: kWhiteBackColor,
                    fontSize: 16,
                  ),
                  specialTextSpanBuilder: EmojiSpecialTextSpanBuilder(),
                )),
              ),
            ),
            200),
      ),
      Visibility(
        visible: widget.message.messageType == MessageType.PICTURE,
        child: maxWidthWidget(
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(widget.message.isOwner ? _textRadius : 0),
                  topRight: Radius.circular(
                      !widget.message.isOwner ? _textRadius : 0),
                  bottomLeft: Radius.circular(_textRadius),
                  bottomRight: Radius.circular(_textRadius)),
              child: Container(
                color: kThemeColor,
                // child: roundItemPadding(
                //     littleTitleFontText(kMessageColor, widget.message.content)),
                child: widget.message.messageType == MessageType.PICTURE
                    ? GestureDetector(
                        onTap: () {
                          onClickPicture(widget.message.imageFileBean!);
                        },
                        child: roundItemPadding(LoadingImage(
                          showLoading: true,
                          imageSrc: widget.message.imageFileBean!.filePath,
                          width: imageWidth,
                          height: imageHeight,
                        )),
                      )
                    : null,
              ),
            ),
            200),
      ),
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
      ),
      Visibility(
        visible: !widget.message.isOwner,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
          child: widget.message.status == MessageStatus.STATUS_SUCCESS_READED
              ? readView()
              : unReadView(),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return itemPadding(Column(
      children: [
        Text(getTime(widget.message.timestamp)),
        GestureDetector(
          onLongPress: () {
            showBottomDialog(
                context, S.current.message_item_title, [S.current.delete],
                (index) {
              if (index == 0) {
                Navigator.of(context).pop();
                if (widget.deleteCallback != null) {
                  widget.deleteCallback!(widget.message);
                }
              }
            });
          },
          child: Row(
            mainAxisAlignment: widget.message.isOwner
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: !widget.message.isOwner
                ? children()
                : children().reversed.toList(),
          ),
        )
      ],
    ));
  }

  void onClickPicture(FileBean fileBean) {
    Routers().openRouter("/picture", {"fileBean": fileBean}, context);
  }
}
