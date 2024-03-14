import 'package:flutter/material.dart';

class EmjKeyboard extends StatefulWidget {
  const EmjKeyboard({super.key});

  @override
  State<EmjKeyboard> createState() => _EmjKeyboardState();
}

class _EmjKeyboardState extends State<EmjKeyboard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return;
        },
      ),
    );
  }
}
