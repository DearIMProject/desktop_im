import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:flutter/material.dart';

class IconItemView extends StatefulWidget {
  const IconItemView({super.key});

  @override
  State<IconItemView> createState() => _IconItemViewState();
}

class _IconItemViewState extends State<IconItemView> {
  String? userIconUrl = UserManager().user?.icon;
  String? username = UserManager().user?.username;
  String? email = UserManager().user?.email;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // widthSpaceSizeBox,
        radiusBorder(
          userIconUrl == null
              ? Image.asset(
                  color: kThemeColor,
                  width: 80,
                  height: 80,
                  'assets/images/failure.png',
                )
              : networkImage(userIconUrl ?? "", 80, 80),
        ),
        widthSpaceSizeBox,
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            littleTitleFontText(kTitleColor, username ?? "username"),
            littleTitleFontText(kTitleColor, email ?? "email@email.com"),
          ],
        )),
        const Icon(Icons.arrow_forward_ios_sharp),
      ],
    );
  }
}
