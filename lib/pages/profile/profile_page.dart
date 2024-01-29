import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/pages/profile/icon_item.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:flutter/material.dart';

typedef JumpFunction = void Function();

class ProfileItem {
  String? title;
  JumpFunction? jumpFunction;
  ProfileItem({this.title, this.jumpFunction});
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

void logout(BuildContext context) {
  LoginService.logout(UserManager.getInstance().userToken(), Callback(
    successCallback: () {
      Routers().openRouter("/login", {}, context);
    },
  ));
}

void sendLog(BuildContext context) {
  //TODO: wmy 发送日志
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tests = [];
    List<ProfileItem> profileItems = [
      ProfileItem(
        title: S.current.logout,
        jumpFunction: () {
          logout(context);
        },
      ),
      ProfileItem(
        title: S.current.send_log,
        jumpFunction: () {
          sendLog(context);
        },
      )
    ];
    for (var i = 0; i < profileItems.length; i++) {
      ProfileItem item = profileItems[i];
      var test = GestureDetector(
        onTap: item.jumpFunction,
        child: Container(
          color: Colors.white,
          height: 60,
          width: double.infinity,
          child: Center(
            child: subTitleFontText(kTitleColor, item.title!),
          ),
        ),
      );
      tests.add(test);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const IconItemView(), ...tests],
      ),
    );
  }
}
