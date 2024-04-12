import 'package:desktop_im/components/common/common_theme.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static final CustomDialog _instance = CustomDialog._internal();
  bool _isShowDialog = false;
  factory CustomDialog() {
    return _instance;
  }

  CustomDialog._internal();

  dismissDialog(BuildContext context) {
    if (_isShowDialog) {
      Navigator.pop(context);
    }
  }

  showLoadingDialog(BuildContext context, String text) {
    double space = 25;
    double top = 15;
    _isShowDialog = true;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: radiusBorder(Container(
              color: kWhiteBackColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(space, top, space, top),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: contentFontText(kTitleColor, text),
                    )
                  ],
                ),
              ),
            )),
          );
        });
  }
}
