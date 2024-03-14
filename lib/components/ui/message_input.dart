import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';

import 'package:flutter/material.dart';

typedef SendCallback = void Function(String text);
typedef ClickCallback = void Function();

// ignore: must_be_immutable
class MessageInputView extends StatefulWidget {
  SendCallback? sendCallback;
  ClickCallback? addClickCallback;
  ClickCallback? emjClickCallback;

  MessageInputView(
      {super.key,
      this.sendCallback,
      this.addClickCallback,
      this.emjClickCallback});

  @override
  State<MessageInputView> createState() => _MessageInputViewState();
}

class _MessageInputViewState extends State<MessageInputView> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    textController.text = "一行字而已";
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        color: kBorderColor,
        width: 1,
      ),
    );
    return Container(
      color: kgrayBackColor,
      child: Column(
        children: [
          const Divider(
            color: kLineColor,
            height: 1,
            thickness: 1,
          ),
          Row(
            children: [
              itemSpaceWidthSizeBox,
              Expanded(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 15, maxHeight: 100),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextField(
                      controller: textController,
                      maxLines: null,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.multiline,
                      onSubmitted: (value) {
                        if (widget.sendCallback != null) {
                          widget.sendCallback!(value);
                        }
                        _focusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        filled: true,
                        fillColor: kWhiteBackColor,
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                      style: const TextStyle(
                          color: kTitleColor, fontSize: 14, letterSpacing: 1),
                    ),
                  ),
                ),
              ),
              itemSpaceWidthSizeBox,
              GestureDetector(
                onTap: () {
                  if (widget.emjClickCallback != null) {
                    widget.emjClickCallback!();
                  }
                },
                child: const Icon(
                    color: kThemeColor, Icons.face_retouching_natural_sharp),
              ),
              itemSpaceWidthSizeBox,
              GestureDetector(
                onTap: () {
                  if (widget.addClickCallback != null) {
                    widget.addClickCallback!();
                  }
                },
                child: const Icon(color: kThemeColor, Icons.add_circle_outline),
              ),
              itemSpaceWidthSizeBox,
            ],
          )
        ],
      ),
    );
  }
}
