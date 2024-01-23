// ignore: file_names
import 'package:desktop_im/components/common/colors.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextInputAction textInputAction;
  final String hintText;
  const LoginTextField(
      {Key? key, required this.textInputAction, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}



// class LoginTextField extends StatefulWidget {
//   const LoginTextField({super.key, this.textInputAction});

//   final TextInputAction? textInputAction;

//   @override
//   State<LoginTextField> createState() => _LoginTextFieldState(textInputAction);
// }

// class _LoginTextFieldState extends State<LoginTextField> {
//   TextInputAction textInputAction;

//   _LoginTextFieldState(textInputAction);

//   @override
//   Widget build(BuildContext context) {
//     return const TextField(
//       style: TextStyle(
//           color: Colors.blue, backgroundColor: Colors.white, fontSize: 14),
//       keyboardType: TextInputType.text,
//       textInputAction: this.textInputAction,
//     );
//   }
// }
