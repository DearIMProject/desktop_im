import 'package:desktop_im/pages/base_page.dart';
import 'package:flutter/material.dart';

class HomePage extends BasePage {
  const HomePage({super.key, super.params});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("widget.title"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have push the button this many times:'),
          ],
        ),
      ),
    );
  }
}
