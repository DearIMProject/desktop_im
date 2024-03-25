import 'package:desktop_im/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Future<void> initState() async {
    super.initState();
    // PermissionStatus status = await Permission.network.status;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(S.current.welcome),
    );
  }
}
