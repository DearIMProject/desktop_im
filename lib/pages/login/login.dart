import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/login/login_button.dart';
import 'package:desktop_im/components/login/login_textfield.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/user/login_service.dart';

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
    username = "iphonexs@apple.com"; // 真机
    // username = "simulator@apple.com"; // 模拟器
    // username = "iphonepromax@apple.com";
    password = "apple";
  }

  void handleLogin() {
    _focusNode1.unfocus();
    _focusNode2.unfocus();
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

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColor,
      appBar: AppBar(
        // title: const Text("title"),
        backgroundColor: kThemeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                focusNode: _focusNode1,
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
                focusNode: _focusNode2,
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
              // SizedBox(
              //   child: LoginButton(
              //     onPressed: () {
              //       Request().testRequest();
              //     },
              //     title: "一个请求",
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
