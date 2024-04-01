import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/address_item.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';

import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/addressbook/service/addressbook_service.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/router/routers.dart';

import 'package:flutter/material.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final List<User> addressUsers = [];

  void requestDatas(BuildContext context) {
    AddressbookService.getAllAddressbook(
      AddressCallback(
        successCallback: (users) {
          addressUsers.addAll(users);
          setState(() {});
        },
        failureCallback: (code, errorStr, data) {
          ToastShowUtils.show(errorStr, context);
        },
      ),
    );
  }

  void click(User addressUser) {
    // Message message = MessageFactory.messageFromType(MessageType.EMPTY_MESSAGE);
    // message.fromId = UserManager.getInstance().uid();
    // message.toId = addressUser.userId;
    // database.addMessage(message);
    Routers().openRouter("/message", {"user": addressUser}, context);
  }

  IMDatabase database = IMDatabase();

  @override
  void initState() {
    super.initState();

    if (database.dbHasInstalled) {
      if (addressUsers.isEmpty) {
        addressUsers.addAll(database.getUsers());
        if (addressUsers.isEmpty) {
          requestDatas(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (addressUsers.isEmpty) {
    //   requestDatas(context);
    // }
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
