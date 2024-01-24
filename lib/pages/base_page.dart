import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  final Map<String, dynamic>? params;
  const BasePage({super.key, this.params});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
