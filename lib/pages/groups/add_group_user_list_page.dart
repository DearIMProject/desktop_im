import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/custom_dialog.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/addressbook/service/addressbook_service.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/groups/select_user_item.dart';
import 'package:desktop_im/pages/groups/services/group_services.dart';
import 'package:desktop_im/pages/message/message_list_type.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:flutter/material.dart';

class AddGroupUserListPage extends BasePage {
  const AddGroupUserListPage({super.key, super.params});

  @override
  State<AddGroupUserListPage> createState() => _AddGroupUserListPageState();
}

class _AddGroupUserListPageState extends State<AddGroupUserListPage> {
  List<User> addressUsers = [];
  List<User> selectUsers = [];
  @override
  void initState() {
    super.initState();
    loadDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: titleFontText(kTitleColor, S.current.select_address_user),
        ),
        body: pagePadding(ListView.builder(
          itemCount: addressUsers.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  User user = addressUsers[index];
                  user.isSelected = !user.isSelected;
                  if (user.isSelected) {
                    selectUsers.add(user);
                  } else {
                    selectUsers.remove(user);
                  }
                  setState(() {});
                });
              },
              child: SelectUserItem(
                user: addressUsers[index],
              ),
            );
          },
        )),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 75,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  _onClickAddGroup();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: double.infinity,
                    color: selectUsers.isNotEmpty ? kThemeColor : kDisableColor,
                    child: Center(
                      child: Text(
                        S.current.add_group,
                        style: const TextStyle(
                            color: kWhiteBackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void loadDatas() {
    AddressbookService.getAllAddressbook(AddressCallback(
      successCallback: (users) {
        setState(() {
          addressUsers.clear();
          for (User user in users) {
            user.isSelected = false;
          }
          addressUsers.addAll(users);
        });
      },
      failureCallback: (code, errorStr, data) {
        ToastShowUtils.show(errorStr, context);
      },
    ));
  }

  // 添加群组
  void _onClickAddGroup() {
    CustomDialog().showLoadingDialog(context, S.current.loading);
    List<int> userIds = [];
    for (User user in selectUsers) {
      userIds.add(user.userId);
    }
    Log.debug("$userIds");
    GroupServices.createGroup(
        userIds,
        GroupCallback(
          successCallback: (group) {
            CustomDialog().dismissDialog(context);
            Log.debug("添加群组成功");
            ToastShowUtils.show(S.current.success, context);
            Log.debug("当前页面pop");
            Navigator.pop(context);
            Log.debug("跳转到群组页面");
            Map<String, dynamic> map = {
              "entity": group,
            };
            Routers().openRouter("/message", map, context);
          },
          failureCallback: (code, errorStr, data) {
            CustomDialog().dismissDialog(context);
            Log.debug("添加群组失败");
            ToastShowUtils.show(errorStr, context);
          },
        ));
  }
}
