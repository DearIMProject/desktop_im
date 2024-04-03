import 'package:desktop_im/components/uikits/emoji/emoji_utils.dart';
import 'package:desktop_im/log/log.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

class EmojiText extends SpecialText {
  static String flag = "[";
  final int start;

  EmojiText(TextStyle? textStyle, {required this.start})
      : super(EmojiText.flag, "]", textStyle);

  @override
  InlineSpan finishText() {
    final String key = toString();
    String emojiName = getContent();
    Log.debug("emojiName = $emojiName");
    double size = textStyle!.fontSize! * 1.5;
    if (EmojiUtils().emojiNames.contains(emojiName)) {
      return ImageSpan(
        AssetImage(EmojiUtils().imagePath(emojiName)),
        imageWidth: size,
        actualText: key,
        imageHeight: size,
        start: start,
        margin: const EdgeInsets.all(2),
      );
    }
    return TextSpan(text: toString(), style: textStyle);
  }
}
