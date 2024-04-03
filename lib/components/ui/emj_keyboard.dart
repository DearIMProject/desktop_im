import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/uikits/emoji/emoji_utils.dart';
import 'package:desktop_im/log/log.dart';
import 'package:flutter/material.dart';

typedef ClickEmjKeyboardCallback = void Function(String empjiName);
typedef EmojisReadyCallback = void Function(List<String> emojis);

class EmjKeyboard extends StatefulWidget {
  ClickEmjKeyboardCallback? clickEmjKeyboardCallback;
  EmojisReadyCallback? emojisReadyCallback;
  EmjKeyboard(
      {super.key, this.clickEmjKeyboardCallback, this.emojisReadyCallback});

  @override
  State<EmjKeyboard> createState() => _EmjKeyboardState();
}

class _EmjKeyboardState extends State<EmjKeyboard> {
  List<String> filePaths = [];
  @override
  void initState() {
    super.initState();
    if (filePaths.isEmpty) {
      filePaths = EmojiUtils().emojiNames;
    }
  }

  @override
  Widget build(BuildContext context) {
    return pagePadding(SizedBox(
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: filePaths.length,
        itemBuilder: (BuildContext context, int index) {
          String filePath = filePaths[index];
          Log.debug("file = ${filePaths[index]}");
          return GestureDetector(
            onTap: () {
              if (widget.clickEmjKeyboardCallback != null) {
                widget.clickEmjKeyboardCallback!("[$filePath]");
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                EmojiUtils().imagePath(filePath),
              ),
            ),
          );
        },
      ),
    ));
  }
}
