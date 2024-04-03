import 'package:desktop_im/components/uikits/emoji/emoji_special_text_span_builder.dart';
import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

/// 主标题
Text titleFontText(Color color, String text) => Text(
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color),
    text);

/// 次级标题
Text subTitleFontText(Color color, String text) => Text(
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
    text);

/// 小标题
Text littleTitleFontText(Color color, String text) => Text(
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
    text);

/// 正文内容
Text contentFontText(Color color, String text) => Text(
    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: color),
    text);
ExtendedText contentOverflowFontText(Color color, String text) => ExtendedText(
      text,
      specialTextSpanBuilder: EmojiSpecialTextSpanBuilder(),
      maxLines: 1,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
          color: color,
          overflow: TextOverflow.ellipsis),
    );

/// 辅助文字
Text assistFontText(Color color, String text) => Text(
    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: color),
    text);
