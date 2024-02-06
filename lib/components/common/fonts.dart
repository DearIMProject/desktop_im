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
Text contentOverflowFontText(Color color, String text) => Text(
    maxLines: 1,
    style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 13,
        color: color,
        overflow: TextOverflow.ellipsis),
    text);

/// 辅助文字
Text assistFontText(Color color, String text) => Text(
    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: color),
    text);
