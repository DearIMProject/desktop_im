import 'dart:io';

import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

typedef ClickFunction = void Function();
typedef IamgeCallback = void Function(String filePath);

class AddKeyboard extends StatefulWidget {
  IamgeCallback? imageCallback;
  AddKeyboard({super.key, required this.imageCallback});

  @override
  State<AddKeyboard> createState() => _AddKeyboardState();
}

class _AddKeyboardState extends State<AddKeyboard> {
  final ImagePicker _picker = ImagePicker();
  List<Widget> icons = [
    const Icon(Icons.image),
    const Icon(Icons.camera_alt),
  ];

  void clickAddImage() async {
    PermissionStatus status = await Permission.photos.request();
    status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (status.isGranted) {
        selectImage();
      }
    } else {
      selectImage();
    }
  }

  void selectImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (widget.imageCallback != null) {
        widget.imageCallback!(pickedFile.path);
      }
    } else {
      Log.debug("null");
    }
  }

  void clickCamera() async {
    PermissionStatus status = await Permission.camera.request();
    status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (status.isGranted) {
        takePhoto();
      }
    } else {
      takePhoto();
    }
  }

  Future<void> takePhoto() async {
    // https://github.com/fluttercandies/flutter_wechat_camera_picker/blob/main/README-ZH.md
    AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(
        enableAudio: false,
        enableRecording: false /*//TODO: wmy */,

        // theme: CameraPicker.themeData(kThemeColor),
      ),
    );
    Log.debug("entity = $entity");
    File? file = await entity!.file;
    if (file != null) {
      Log.debug("file.path = ${file.path}");
      // Navigator.of(context).pop();
      if (widget.imageCallback != null) {
        widget.imageCallback!(file.path);
      }
    }
  }

  Future<void> takePhotoForMe() async {
    Map<String, dynamic> params = {};
    Routers().openRouter("/toke_photo", params, context);
    // cameraController
  }

  @override
  Widget build(BuildContext context) {
    List<ClickFunction> clicks = [
      () => clickAddImage(),
      () => clickCamera(),
    ];
    return SizedBox(
      // width: 100,
      height: 200,
      child: pagePadding(GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 每一行的列数
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: icons.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                ClickFunction function = clicks[index];
                function();
              },
              child: Container(
                color: kgrayBackColor,
                // width: 20,
                // height: 20,
                child: icons[index],
              ));
        },
      )),
    );
  }
}
