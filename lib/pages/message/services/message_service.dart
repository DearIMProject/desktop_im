import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/fileBean.dart';
import 'package:desktop_im/network/request.dart';

enum ImageType {
  image,
  text,
}

class MessageService {
  Future<FileBean?> uploadFile(String filePath, ImageType imageType) {
    Completer<FileBean?> completer = Completer();
    Request().uploadRequest(
        "file/uploadBucket",
        filePath,
        {"fileType": imageType.toString().split(".").last},
        RequestCallback(
          successCallback: (data) {
            Log.debug("data = $data");
            FileBean file = FileBean.fromJson(data["file"]);
            completer.complete(file);
          },
          failureCallback: (code, errorStr, data) {
            completer.complete(null);
          },
        ));
    return completer.future;
  }
}
