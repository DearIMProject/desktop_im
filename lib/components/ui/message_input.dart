import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/uikits/emoji/emoji_special_text_span_builder.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef SendCallback = void Function(String text);
typedef OnTextChangeback = void Function(String text);
typedef ClickCallback = void Function();

typedef AddTextCallback = void Function(String text);
typedef AudioCallback = void Function(bool isAudioPress);
typedef EmojiReadyCallback = void Function(List<String> emojiNames);

class MesssageInputViewController {
  AddTextCallback? callback;
  EmojiReadyCallback? emojiReadyCallback;
  OnTextChangeback? textChangeback;
}

// ignore: must_be_immutable
class MessageInputView extends StatefulWidget {
  SendCallback? sendCallback;
  ClickCallback? addClickCallback;
  ClickCallback? emjClickCallback;
  AudioCallback? audioCallback;
  MesssageInputViewController? controller;

  MessageInputView(
      {super.key,
      this.sendCallback,
      this.addClickCallback,
      this.emjClickCallback,
      this.audioCallback,
      this.controller});

  @override
  State<MessageInputView> createState() => _MessageInputViewState();
}

class _MessageInputViewState extends State<MessageInputView> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<ExtendedTextFieldState> _key =
      GlobalKey<ExtendedTextFieldState>();
  final TextEditingController textController = TextEditingController();
  final EmojiSpecialTextSpanBuilder builder = EmojiSpecialTextSpanBuilder();
  // bool _sendBtnEnabled = false;
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.callback = (emojiName) {
        insertText(emojiName);
      };
    }
  }

//插入文本
  void insertText(String text) {
    final TextEditingValue value = textController.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      textController.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      textController.value = TextEditingValue(
          text: text,
          selection:
              TextSelection.fromPosition(TextPosition(offset: text.length)));
    }
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _key.currentState?.bringIntoView(textController.selection.base);
    });
  }

  void manualDelete() {
    //delete by code
    final TextEditingValue _value = textController.value;
    final TextSelection selection = _value.selection;
    if (!selection.isValid) {
      return;
    }

    TextEditingValue value;
    final String actualText = _value.text;
    if (selection.isCollapsed && selection.start == 0) {
      return;
    }

    final int start =
        selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;
    // improve the case of emoji
    // https://github.com/dart-lang/sdk/issues/35798
    final CharacterRange characterRange =
        CharacterRange.at(actualText, start, end);
    value = TextEditingValue(
      text: characterRange.stringBefore + characterRange.stringAfter,
      selection:
          TextSelection.collapsed(offset: characterRange.stringBefore.length),
    );

    final TextSpan oldTextSpan = builder.build(_value.text);

    value = ExtendedTextLibraryUtils.handleSpecialTextSpanDelete(
      value,
      _value,
      oldTextSpan,
      null,
    );

    textController.value = value;
  }

  bool isAudioType = false;
  bool isAudioTap = false;
  @override
  Widget build(BuildContext context) {
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
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    isAudioType = !isAudioType;

                    setState(() {});
                  },
                  child: Icon(isAudioType
                      ? Icons.spatial_audio_off_outlined
                      : Icons.keyboard_alt_outlined),
                ),
              ),
              itemSpaceWidthSizeBox,
              Expanded(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 15, maxHeight: 100),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: isAudioType
                        ? Listener(
                            onPointerDown: (event) {
                              Log.debug("onPointerDown $event");
                              //  按下开始录音
                              isAudioTap = true;
                              if (widget.audioCallback != null) {
                                widget.audioCallback!(isAudioTap);
                              }
                              setState(() {});
                            },
                            onPointerUp: (event) {
                              Log.debug("onPointerUp $event");
                              // 抬起结束录音
                              isAudioTap = false;
                              if (widget.audioCallback != null) {
                                widget.audioCallback!(isAudioTap);
                              }
                              setState(() {});
                            },
                            child: GestureDetector(
                              // onPanUpdate: (details) {
                              //   Log.debug("onPanUpdate $details");
                              // },
                              child: radiusBorder(Container(
                                color: kWarningColor,
                                height: 48,
                                child: Center(
                                  child: subTitleFontText(
                                      kWhiteBackColor,
                                      isAudioTap
                                          ? S.current.release_to_send
                                          : S.current.press_to_speak),
                                ),
                              )),
                            ),
                          )
                        : extendedTextField(border),
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

  ExtendedTextField extendedTextField(OutlineInputBorder border) {
    return ExtendedTextField(
      key: _key,
      minLines: 1,
      maxLines: 2,
      specialTextSpanBuilder: builder,
      controller: textController,
      onTapOutside: (_) {
        _focusNode.unfocus();
      },
      strutStyle: const StrutStyle(),
      onChanged: (string) {
        if (widget.controller != null &&
            widget.controller!.textChangeback != null) {
          widget.controller!.textChangeback!(string);
        }
      },
      focusNode: _focusNode,
      keyboardType: TextInputType.multiline,
      onSubmitted: (value) {
        if (widget.sendCallback != null) {
          widget.sendCallback!(value);
        }
        textController.text = "";
        _focusNode.requestFocus();
      },
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        filled: true,
        fillColor: kWhiteBackColor,
        enabledBorder: border,
        focusedBorder: border,
      ),
      style:
          const TextStyle(color: kTitleColor, fontSize: 16, letterSpacing: 1),
    );
  }
}
