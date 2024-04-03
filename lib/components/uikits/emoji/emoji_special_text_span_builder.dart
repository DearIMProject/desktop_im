import 'package:desktop_im/components/uikits/emoji/emoji_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

class EmojiSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      required int index}) {
    if (flag == "") {
      return null;
    }
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle, start: index - (EmojiText.flag.length - 1));
    }
    return null;
  }
}

// enum BuilderType { extendedText, extendedTextField }
