import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:desktop_im/log/log.dart';
import 'package:flutter/material.dart';

typedef DialogCallback = void Function(int index);

double _kTitleHeight = 60;
double _kSubtitleHeight = 60;
double _kContentTitleHeight = 56;
showBottomDialog(BuildContext context, String title, List<String> texts,
    DialogCallback callback) {
  showBottomSubTitleDialog(context, title, "", texts, callback);
}

showBottomSubTitleDialog(BuildContext context, String title, String sutTitle,
    List<String> texts, DialogCallback callback) {
  if (texts.isEmpty) return;
  double height = 0;
  if (title.isNotEmpty) {
    height += _kTitleHeight;
  }
  if (sutTitle.isNotEmpty) {
    height += _kSubtitleHeight;
  }
  height += _kContentTitleHeight * texts.length;
  showModalBottomSheet(
      useSafeArea: true,
      isDismissible: true,
      context: context,
      builder: (BuildContext build) {
        return Container(
          height: height,
          color: kBorderColor,
          child: Center(
            child: Column(
              children: _texts(title, sutTitle, texts, callback, context),
            ),
          ),
        );
      });
}

List<Widget> _texts(String title, String subtitle, List<String> texts,
    DialogCallback callback, BuildContext context) {
  List<Widget> result = [];

  if (title.isNotEmpty) {
    result.add(titleFontText(kTitleColor, title));
  }
  if (subtitle.isNotEmpty) {
    result.add(contentFontText(kTitleColor, subtitle));
  }
  for (var i = 0; i < texts.length; i++) {
    String text = texts[i];
    result.add(GestureDetector(
      onTap: () {
        callback(i);
        Log.debug("GestureDetector");
      },
      child: Container(
        // constraints: const BoxConstraints.expand(
        // width: double.infinity,
        // ),
        // color: Colors.red,
        height: _kContentTitleHeight,
        child: Center(child: subTitleFontText(kContentColor, text)),
      ),
    ));
  }

  return result;
}
