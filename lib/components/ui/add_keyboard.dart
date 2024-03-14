import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/common_theme.dart';
import 'package:flutter/material.dart';

typedef ClickFunction = void Function();

class AddKeyboard extends StatefulWidget {
  const AddKeyboard({super.key});

  @override
  State<AddKeyboard> createState() => _AddKeyboardState();
}

class _AddKeyboardState extends State<AddKeyboard> {
  List<Widget> icons = [
    const Icon(Icons.image),
    const Icon(Icons.camera_alt),
  ];
  List<ClickFunction> clicks = [
    () => clickAddImage(),
  ];

  static clickAddImage() {}

  @override
  Widget build(BuildContext context) {
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
                if (index == 0) {}
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
