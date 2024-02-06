import 'package:desktop_im/components/common/common_theme.dart';

import 'package:flutter/material.dart';

typedef SendCallback = void Function(String text);

// ignore: must_be_immutable
class MessageInputView extends StatefulWidget {
  SendCallback? sendCallback;
  MessageInputView({super.key, this.sendCallback});

  @override
  State<MessageInputView> createState() => _MessageInputViewState();
}

class _MessageInputViewState extends State<MessageInputView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    textController.text =
        "一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字一段很长的字";
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
      child: SafeArea(
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
                        keyboardType: TextInputType.multiline,
                        onSubmitted: (value) {
                          if (widget.sendCallback != null) {
                            widget.sendCallback!(value);
                          }
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
