import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/address_item.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/log/log.dart';

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

class _AddressBookPageState extends State<AddressBookPage>
    implements IMDatabaseListener {
  final List<User> addressUsers = [];
  @override
  DatabaseCompleteCallback? completeCallback;

  @override
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
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
    Routers().openRouter("/message", {"user": addressUser}, context);
  }

  IMDatabase database = IMDatabase.getInstance();
  _AddressBookPageState() {
    database.addListener(this);
  }

  @override
  void initState() {
    super.initState();
    Log.debug("addresspage initState");
    completeCallback = () {
      Log.debug("address book page 收到数据库初始化成功");
      requestDatas(context);
    };
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
