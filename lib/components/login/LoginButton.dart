// ignore: file_names
import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  const LoginButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<LoginButton> createState() => _LoginButtonState(onPressed, title);
}

class _LoginButtonState extends State<LoginButton> {
  VoidCallback onPressed;
  String title;

  _LoginButtonState(this.onPressed, this.title);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: kTitleColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        side: const BorderSide(width: 0, color: Colors.transparent),
      ),
      child: subTitleFontText(kWhiteBackColor, title),
    );
  }
}
