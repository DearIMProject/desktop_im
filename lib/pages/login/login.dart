import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/login/LoginButton.dart';
import 'package:desktop_im/components/login/LoginTextField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void handleLogin() {
    if (kDebugMode) {
      print("handleLogin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColor,
      appBar: AppBar(
        // title: const Text("title"),
        backgroundColor: kThemeColor,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
                style: TextStyle(
                  color: kWhiteBackColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                "登录"),
            SizedBox(
              height: 50,
            ),
            LoginTextField(
              textInputAction: TextInputAction.next,
              hintText: "请输入登录账号或邮箱",
            ),
            SizedBox(
              height: 2,
            ),
            LoginTextField(
              textInputAction: TextInputAction.done,
              hintText: "请输入密码",
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: LoginButton(
                title: "登录",
                onPressed: handleLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
