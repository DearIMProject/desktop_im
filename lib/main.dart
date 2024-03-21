// Material 风格的UI组件
import 'dart:async';

import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/notification/notification_stream.dart';
import 'package:desktop_im/notification/notifications.dart';
import 'package:desktop_im/pages/datas/db_test_page.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/home/home_page.dart';
import 'package:desktop_im/pages/login/login.dart';
import 'package:desktop_im/pages/message/message_list_page.dart';
import 'package:desktop_im/pages/test/test_page.dart';
import 'package:desktop_im/pages/welcome/welcome_page.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/tcpconnect/connect/connect_test_page.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  IMDatabase database = IMDatabase.getInstance();
  database.init().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 长连接
  IMClient connectManager = IMClient.getInstance();

  /// 数据库
  IMDatabase database = IMDatabase.getInstance();
  @override
  void initState() {
    super.initState();
    // 打印token
  }

  _MyAppState() {
    init();
  }
  void init() {
    connectManager.init();
    NotificationStream().stream.listen((notification) {
      Log.debug("收到消息:$notification");
      if (notification.contains(kLoginSuccessNotification)) {
        // 初始化数据库
        database
            .install(UserManager.getInstance().uid().toString())
            .then((value) {
          connectManager.connect();
        });
      }
      if (notification.contains(kLogoutSuccessNotification)) {
        connectManager.close();
      }
      if (notification.contains(kAddressReadyNotification)) {
        //TODO: wmy 请求了所有的通讯录数据，可以进行登录操作了
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    configRouters(context);
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      // 插件目前不完善手动处理简繁体
      localeResolutionCallback: (locale, supportLocales) {
        // 中文 简繁体处理
        if (locale?.languageCode == 'zh') {
          // zh-CN：地区限制匹配规范，表示用在中国大陆区域的中文。
          // 包括各种大方言、小方言、繁体、简体等等都可以被匹配到。
          if (locale?.scriptCode == 'Hant') {
            // zh-Hant和zh-CHT相同相对应;
            return const Locale('zh', 'HK'); //繁体
          }
        }
        return null;
      },
      debugShowCheckedModeBanner: !kDebugMode,
      title: 'IM Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kThemeColor,
        ),
        useMaterial3: true,
      ),
      routes: Routers().routers(),
      home: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const WelcomePage();
          }
          if (snapshot.data!.token.isNotEmpty) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }

  void configRouters(BuildContext context) {
    Routers()
        .addPageRouter("/home_tab", (context) => const HomePage(), context);
    Routers()
        .addPageRouter("/login_page", (context) => const LoginPage(), context);
    Routers().addPageParamRouter(
        "/message",
        (context) => const MessageListPage(),
        (aparams) => MessageListPage(
              params: aparams,
            ),
        context);
    Routers().registerRouter("/home", (params, context) {
      Navigator.of(context).pushReplacementNamed("/home_tab");
    });
    Routers().registerRouter("/login", (params, context) {
      Navigator.of(context).pushReplacementNamed("/login_page");
    });
    if (kDebugMode) {
      Routers()
          .addPageRouter("/test_page", (context) => const TestPage(), context);
      Routers().addPageRouter(
          "/test_connect_page", (context) => const ConnectTestPage(), context);
      Routers().addPageRouter(
          "/test_db_page", (context) => const DatabaseTestPage(), context);
    }
  }
}

Future<User> getUser() async {
  var completer = Completer<User>();
  User user = User();

  user.restore().then((hasUser) {
    if (hasUser) {
      User? aUser = UserManager.getInstance().user;
      if (aUser != null) {
        user = aUser;
      }
    }
    completer.complete(user);
  });
  return completer.future;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    //setstate自增，通知flutter框架，状态发生改变
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have push the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
