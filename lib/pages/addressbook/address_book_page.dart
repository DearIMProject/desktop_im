import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/address_item.dart';
import 'package:desktop_im/components/ui/custom_dialog.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/models/message/chat_entity.dart';

import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/addressbook/service/addressbook_service.dart';
import 'package:desktop_im/pages/chat/chat_user_item.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/groups/services/group_services.dart';
import 'package:desktop_im/pages/message/message_list_type.dart';
import 'package:desktop_im/router/routers.dart';

import 'package:flutter/material.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final List<ChatEntity> addressUsers = [];

  void requestDatas() {
    // CustomDialog().showLoadingDialog(context, "");
    AddressbookService.getAllAddressbook(
      AddressCallback(
        successCallback: (users) {
          addressUsers.addAll(users);
          GroupServices.getGroups(GroupListCallback(
            successCallback: (groups) {
              // CustomDialog().dismissDialog(context);
              addressUsers.addAll(groups);
              setState(() {});
            },
            failureCallback: (code, errorStr, data) {
              // CustomDialog().dismissDialog(context);
              ToastShowUtils.show(errorStr, context);
            },
          ));
          setState(() {});
        },
        failureCallback: (code, errorStr, data) {
          CustomDialog().dismissDialog(context);
          ToastShowUtils.show(errorStr, context);
        },
      ),
    );
  }

  void click(ChatEntity entity) {
    Routers().openRouter("/message", {"entity": entity}, context);
  }

  IMDatabase database = IMDatabase();

  @override
  void initState() {
    super.initState();

    if (database.dbHasInstalled) {
      // if (addressUsers.isEmpty) {
      requestDatas();
      // }
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
        ChatEntity addressUser = addressUsers[index];
        return GestureDetector(
          onTap: () {
            click(addressUser);
          },
          child: AddressChatEntityItem(user: addressUser),
        );
      },
    ));
  }
}
