import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:desktop_im/components/ui/custom_dialog.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:flutter/material.dart';

class TestDialogPage extends StatefulWidget {
  const TestDialogPage({super.key});

  @override
  State<TestDialogPage> createState() => _TestDialogPageState();
}

class _TestDialogPageState extends State<TestDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleFontText(kTitleColor, "dialog test"),
      ),
      body: pagePadding(ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                CustomDialog().showLoadingDialog(context, S.current.loading);
                Future.delayed(const Duration(seconds: 3), () {
                  CustomDialog().dismissDialog(context);
                });
              },
              child: subTitleFontText(kTitleColor, "显示一个loading"),
            );
          }
          return GestureDetector(
            child: const Text("data"),
          );
        },
      )),
    );
  }
}
