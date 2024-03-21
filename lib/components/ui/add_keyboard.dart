import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

typedef ClickFunction = void Function();
typedef IamgeCallback = void Function(String filePath);

class AddKeyboard extends StatefulWidget {
  IamgeCallback? imageCallback;
  AddKeyboard({super.key, this.imageCallback});

  @override
  State<AddKeyboard> createState() => _AddKeyboardState();
}

class _AddKeyboardState extends State<AddKeyboard> {
  List<Widget> icons = [
    const Icon(Icons.image),
    const Icon(Icons.camera_alt),
  ];

  void clickAddImage() async {
    PermissionStatus status = await Permission.photos.request();
    status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    } else {
      selectImage();
    }
  }

  void selectImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (widget.imageCallback != null) {
        widget.imageCallback!(pickedFile.path);
      }
    } else {
      Log.debug("null");
    }
  }

  void clickCamera() async {
    Log.debug("clickCamera");
    PermissionStatus status = await Permission.camera.request();
    Log.debug("$status");
    status = await Permission.camera.status;
    Log.debug("$status");
    Log.debug("${status.isGranted}");
    if (!status.isGranted) {
      status = await Permission.camera.request();
      Log.debug("$status");
    } else {
      //TODO: wmy 这里换起相机后返回数据
      selectImage();
    }
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
