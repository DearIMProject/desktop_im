import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/models/user.dart';
import 'package:flutter/material.dart';

class AddressUserItem extends StatefulWidget {
  final User? user;
  const AddressUserItem({super.key, this.user});

  @override
  State<AddressUserItem> createState() => _AddressUserItemState();
}

class _AddressUserItemState extends State<AddressUserItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          radiusBorder(networkImage(widget.user!.icon, 40, 40)),
          itemSpaceSizeBox,
          subTitleFontText(kTitleColor, widget.user!.username),
        ],
      ),
    );
  }
}
