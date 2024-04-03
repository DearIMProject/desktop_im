import 'package:desktop_im/log/log.dart';
import 'package:flutter/material.dart';

class RichTextEditingController extends TextEditingController {
  List<String> fileNames = [];
  bool isContainerEmoji = false;
  List<String> contents = [];
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    Log.debug("text = $text");
    Log.debug("value.text = ${value.text}");
    RegExp exp = RegExp(r"\[([^\]]+)\]"); // 匹配中括号内的任意内容

    Iterable<Match> matches = exp.allMatches(text); // 匹配所有符合条件的字符串

    List<String> results = [];
    List<String> words = text.split(exp);
    List<String> matchWords = [];
    for (Match match in matches) {
      matchWords.add(match.group(0)!); // 将匹配到的字符串添加到列表中
    }
    if (text.startsWith("[")) {
      for (var i = 0; i < matchWords.length; i++) {
        results.add(matchWords[i]);
        if (words[i].isNotEmpty) {
          results.add(words[i]);
        }
      }
    } else {
      for (var i = 0; i < matchWords.length; i++) {
        if (words[i].isNotEmpty) {
          results.add(words[i]);
        }

        results.add(matchWords[i]);
      }
      if (words.last.isNotEmpty) {
        results.add(words.last);
      }
    }
    contents.clear();
    contents.addAll(results);
    List<InlineSpan> children = [];
    bool isContainerEmoji = false;
    for (String aText in results) {
      if (aText.startsWith("[")) {
        String subText = aText.substring(1, aText.length - 1);
        Log.debug("subText = $subText");
        if (fileNames.contains(subText)) {
          isContainerEmoji = true;
          children.add(WidgetSpan(
              child: Image.asset(
            "assets/images/emojis/$subText@2x.png",
            width: 22,
          )));
        } else {
          children.add(TextSpan(text: aText, style: style));
        }
      } else {
        children.add(TextSpan(text: aText, style: style));
      }
    }
    this.isContainerEmoji = isContainerEmoji;
    return TextSpan(children: children);
  }
}
