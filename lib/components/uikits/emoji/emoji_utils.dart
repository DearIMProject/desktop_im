import 'dart:convert';

import 'package:flutter/services.dart';

class EmojiUtils {
  static final EmojiUtils _instance = EmojiUtils._internal();

  factory EmojiUtils() {
    return _instance;
  }

  void setup() {
    _instance._getEmojiNames();
  }

  EmojiUtils._internal();

  final List<String> _emojiNames = [];

  List<String> get emojiNames {
    return _emojiNames;
  }

  String imagePath(String emojiName) {
    return "assets/images/emojis/$emojiName@2x.png";
  }

  Future<void> _getEmojiNames() async {
    final assetManifest = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(assetManifest);

    final List<String> assetPaths = manifest.keys.toList();

    for (final assetPath in assetPaths) {
      if (!assetPath.contains("assets/images/emojis")) {
        continue;
      }
      emojiNames.add(assetPath.split("/").last.split("@").first);
    }
  }
}
