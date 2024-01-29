import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:desktop_im/components/ui/bottom_tabbar_item.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/pages/addressbook/address_book_page.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/chat/chat_page.dart';
import 'package:desktop_im/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends BasePage {
  const HomePage({super.key, super.params});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? pageController;

  int _currentIndex = 2;
  @override
  void initState() {
    super.initState();
    initPageController();
    // autoLogin();
  }

  void initPageController() {
    if (pageController == null) {
      pageController =
          PageController(initialPage: _currentIndex, keepPage: true);
      pageController!.addListener(() {
        //PageView滑动的距离
        // double offset = pageController!.offset;
        //当前显示的页面的索引
        double? page = pageController!.page;
        if (page != null) {
          setState(() {
            _currentIndex = page.round();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomTabbarItem> tabbarItems = [
      BottomTabbarItem(S.current.chat, Icons.chat, true),
      BottomTabbarItem(S.current.addressbook, Icons.menu_book, false),
      BottomTabbarItem(S.current.account, Icons.account_circle, false),
    ];
    List<BottomNavigationBarItem> tabs = [];
    for (var i = 0; i < tabbarItems.length; i++) {
      BottomTabbarItem bottomTabbarItem = tabbarItems[i];
      var tab = BottomNavigationBarItem(
        // text: bottomTabbarItem.title,
        label: bottomTabbarItem.title,
        icon: Icon(bottomTabbarItem.icon),
      );
      tabs.add(tab);
    }
    return Scaffold(
      appBar: AppBar(
        title: titleFontText(kTitleColor, S.current.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: tabs,
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          pageController?.animateToPage(value,
              duration: const Duration(microseconds: 250),
              curve: Curves.bounceInOut);
        },
      ),
      body: PageView(
          controller: pageController,
          onPageChanged: (value) {
            _currentIndex = value;
          },
          children: const [
            ChatPage(),
            AddressBookPage(),
            ProfilePage(),
          ]),
    );
  }
}
