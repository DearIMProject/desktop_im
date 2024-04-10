import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:desktop_im/components/ui/bottom_tabbar_item.dart';
import 'package:desktop_im/components/uikits/toast_show_utils.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/notification/notification_stream.dart';
import 'package:desktop_im/notification/notifications.dart';
import 'package:desktop_im/pages/addressbook/address_book_page.dart';
import 'package:desktop_im/pages/addressbook/service/addressbook_service.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/chat/chat_page.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/profile/profile_page.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:flutter/material.dart';

class HomePage extends BasePage {
  const HomePage({super.key, super.params});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    implements IMDatabaseListener, IMClientListener {
  @override
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  @override
  DatabaseCompleteCallback? completeCallback;
  @override
  DatabaseCompleteCallback? dataChangeCallback;

  @override
  IMClientConnectSuccessCallback? connectSuccessCallback;

  @override
  IMClientReceiveMessageCallback? messageCallback;

  @override
  IMClientUnReadedMessageCallback? unreadMessageCallback;

  PageController? pageController;
  BottomTabbarItem chatItem =
      BottomTabbarItem(S.current.chat, Icons.chat, true, 0);
  BottomTabbarItem addressItem =
      BottomTabbarItem(S.current.addressbook, Icons.menu_book, false, 0);
  BottomTabbarItem profileItem =
      BottomTabbarItem(S.current.account, Icons.account_circle, false, 0);
  int _currentIndex = 0;
  bool hasAutoLogin = false;
  IMDatabase database = IMDatabase();
  _HomePageState() {
    init();
  }

  @override
  void dispose() {
    database.removeListener(this);
    super.dispose();
  }

  void init() {
    initPageController();
    unreadMessageNumberChange = (unreadNumber) {
      setState(() {
        chatItem.badgeNumber = unreadNumber;
      });
    };
    database.addListener(this);
    IMClient().addListener(this);
    connectSuccessCallback = (success) {
      if (!success) {
        return;
      }
      Log.debug("home page listener completeCallback");
      AddressbookService.getAllAddressbook(AddressCallback(
        successCallback: (users) {
          Log.debug("通讯录信息都获取成功");
          NotificationStream().publish(kAddressReadyNotification);
          Log.debug("发送Login消息");
          IMClient().sendRequestLoginMessage();
        },
        failureCallback: (code, errorStr, data) {
          ToastShowUtils.show(errorStr, context);
        },
      ));
    };

    completeCallback = () {
      Log.debug("获取未读信息 ${database.badgeValue}");
      setState(() {
        chatItem.badgeNumber = database.badgeValue;
        Log.debug("获取数量 num = ${chatItem.badgeNumber}");
      });
    };

    dataChangeCallback = () {
      chatItem.badgeNumber = database.badgeValue;
      Log.debug("获取数量 num = ${chatItem.badgeNumber}");
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          setState(() {});
        },
      );
    };
    if (database.dbHasInstalled) {
      chatItem.badgeNumber = database.badgeValue;
      Log.debug("获取数量 num = ${chatItem.badgeNumber}");
    }
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

  void configAutoLogin(BuildContext context) {
    if (hasAutoLogin) {
      return;
    }
    hasAutoLogin = true;
    String token = UserManager().userToken();
    Log.debug("token = $token");
    if (token.isNotEmpty) {
      Log.debug("调用自动登录");
      LoginService.autoLogin(
          token,
          Callback(
            successCallback: () {
              // hasAutoLogin = true;
            },
            failureCallback: (code, errorStr, data) {
              // hasAutoLogin = false;
              Routers().openRouter("/login", {}, context);
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomTabbarItem> tabbarItems = [chatItem, addressItem, profileItem];
    List<BottomNavigationBarItem> tabs = [];
    for (var i = 0; i < tabbarItems.length; i++) {
      BottomTabbarItem bottomTabbarItem = tabbarItems[i];
      var tab = BottomNavigationBarItem(
        label: bottomTabbarItem.title,
        icon: Badge(
          isLabelVisible: bottomTabbarItem.badgeNumber != 0,
          label: Text("${bottomTabbarItem.badgeNumber}"),
          child: Icon(bottomTabbarItem.icon),
        ),
      );
      tabs.add(tab);
    }
    configAutoLogin(context);

    return Scaffold(
      appBar: AppBar(
        title: titleFontText(kTitleColor, S.current.title),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            onSelected: (value) {
              if (value == S.current.add_group) {
                jumpToAddGroup();
              }
            },
            itemBuilder: (context) => popupActions(),
            child: const SizedBox(
              width: 60,
              height: 60,
              child: Icon(Icons.add),
            ),
          ),
          itemSpaceHeightSizeBox
        ],
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

  @override
  DatabaseAddReadableMessage? addReadableCallback;

  @override
  IMClientTransparentCallback? transparentCallback;

// 添加text列表
  List<String> popupTexts() {
    return [S.current.add_group];
  }

  List<PopupMenuEntry<String>> popupActions() {
    List<String> tests = popupTexts();
    List<PopupMenuEntry<String>> widgets = [];
    for (var e in tests) {
      widgets.add(PopupMenuItem(
        value: e,
        child: subTitleFontText(kTitleColor, e),
      ));
    }
    return widgets;
  }

  void jumpToAddGroup() {
    Routers().openRouter("/add_group", {}, context);
  }
}
