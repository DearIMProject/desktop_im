import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/addressbook/service/addressbook_service.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/groups/select_user_item.dart';
import 'package:flutter/material.dart';

class AddGroupUserListPage extends BasePage {
  const AddGroupUserListPage({super.key, super.params});

  @override
  State<AddGroupUserListPage> createState() => _AddGroupUserListPageState();
}

class _AddGroupUserListPageState extends State<AddGroupUserListPage> {
  List<User> addressUsers = [];
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
                  addressUsers[index].isSelected =
                      !addressUsers[index].isSelected;
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
                    color: kThemeColor,
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
          addressUsers.addAll(users);
        });
      },
      failureCallback: (code, errorStr, data) {
        ToastShowUtils.show(errorStr, context);
      },
    ));
  }

  // 添加群组
  void _onClickAddGroup() {}
}
