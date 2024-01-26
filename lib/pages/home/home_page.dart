import 'package:desktop_im/components/ui/bottom_menu_tabbar_view.dart';
import 'package:desktop_im/components/ui/bottom_tabbar_item.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/pages/addressbook/address_book_page.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/chat/chat_page.dart';
import 'package:desktop_im/pages/profile/profile_page.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:flutter/material.dart';

class HomePage extends BasePage {
  const HomePage({super.key, super.params});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    initPageController();
    // autoLogin();
  }

  void initPageController() {
    if (pageController == null) {
      pageController = PageController(initialPage: 0, keepPage: true);
      pageController!.addListener(() {
        //PageView滑动的距离
        double offset = pageController!.offset;
        //当前显示的页面的索引
        double? page = pageController!.page;
        print("pageView 滑动的距离 $offset  索引 $page");
      });
    }
  }

  /// 自动登录
  void autoLogin() {
    LoginService.autoLogin(UserManager.getInstance().userToken());
  }

  @override
  Widget build(BuildContext context) {
    List<BottomTabbarItem> tabbarItems = [
      BottomTabbarItem(S.current.chat, Icons.chat, true),
      BottomTabbarItem(S.current.addressbook, Icons.menu_book, false),
      BottomTabbarItem(S.current.account, Icons.account_circle, false),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.current.title),
      ),
      bottomNavigationBar: BottomMenuTabbarView(
        tabbarItems: tabbarItems,
        selectedIndex: 0,
        bottomDelegate: (index) {
          pageController?.animateToPage(index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        },
      ),
      body: SizedBox(
        child: PageView(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) {},
          children: const [
            ChatPage(),
            AddressBookPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
