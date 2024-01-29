import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/login/login_button.dart';
import 'package:desktop_im/components/login/login_textfield.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 登录页面
class LoginPage extends BasePage {
  const LoginPage({super.key, super.params});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String username;
  late String password;
  @override
  void initState() {
    super.initState();
    username = "305662816@qq.com";
    password = "apple";
  }

  void handleLogin() {
    if (kDebugMode) {
      print("handleLogin");
    }

    LoginService.login(
        username,
        password,
        Callback(
          successCallback: () {
            ToastShowUtils.show(S.of(context).success, context);
            Routers().openRouter("/home", {}, context);
          },
          failureCallback: (code, errorStr, data) {
            ToastShowUtils.show(errorStr, context);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColor,
      appBar: AppBar(
        // title: const Text("title"),
        backgroundColor: kThemeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
                style: const TextStyle(
                  color: kWhiteBackColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                S.of(context).login),
            const SizedBox(
              height: 50,
            ),
            LoginTextField(
              defaultText: username,
              onChanged: (value) {
                username = value;
              },
              textInputAction: TextInputAction.next,
              hintText: S.of(context).username_tip,
            ),
            const SizedBox(
              height: 2,
            ),
            LoginTextField(
              defaultText: password,
              onChanged: (value) {
                password = value;
              },
              textInputAction: TextInputAction.done,
              hintText: S.of(context).password_tip,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: LoginButton(
                title: S.of(context).login,
                onPressed: handleLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
