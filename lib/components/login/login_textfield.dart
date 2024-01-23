import 'package:desktop_im/components/common/colors.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final TextInputAction textInputAction;
  final String hintText;
  final ValueChanged<String> onChanged;
  final String defaultText;
  const LoginTextField(
      {Key? key,
      required this.textInputAction,
      required this.hintText,
      required this.onChanged,
      required this.defaultText})
      : super(key: key);

  @override
  State<LoginTextField> createState() =>
      // ignore: no_logic_in_create_state
      _LoginTextFieldState(textInputAction, hintText, onChanged, defaultText);
}

class _LoginTextFieldState extends State<LoginTextField> {
  TextInputAction textInputAction;
  String hintText;
  String defaultText;
  ValueChanged<String> onChanged;

  _LoginTextFieldState(
      this.textInputAction, this.hintText, this.onChanged, this.defaultText);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: textInputAction,
      style: const TextStyle(
          backgroundColor: Colors.transparent, color: kTitleColor),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: kWhiteBackColor,
        hintStyle: const TextStyle(color: kDisableColor, fontSize: 14),
        border: InputBorder.none,
      ),
      controller: TextEditingController(text: defaultText),
    );
  }
}
