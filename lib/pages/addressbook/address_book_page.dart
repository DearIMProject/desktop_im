import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/address_item.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/addressbook/service/addressbook_service.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:flutter/material.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  List<User> addressUsers = [];

  void requestDatas(BuildContext context) {
    AddressbookService.getAllAddressbook(AddressCallback(
      successCallback: (users) {
        addressUsers = [];
        addressUsers.addAll(users);
        setState(() {});
      },
      failureCallback: (code, errorStr, data) {
        ToastShowUtils.show(errorStr, context);
      },
    ));
  }

  void click(User addressUser) {
    Routers().openRouter("/message", {"user": addressUser}, context);
  }

  @override
  Widget build(BuildContext context) {
    if (addressUsers.isEmpty) {
      requestDatas(context);
    }
    return pagePadding(ListView.builder(
      itemCount: addressUsers.length,
      itemBuilder: (BuildContext context, int index) {
        User addressUser = addressUsers[index];
        return GestureDetector(
          onTap: () {
            click(addressUser);
          },
          child: AddressUserItem(user: addressUser),
        );
      },
    ));
  }
}
