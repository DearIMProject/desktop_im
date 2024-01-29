// Material 风格的UI组件
import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/pages/home/home_page.dart';
import 'package:desktop_im/pages/login/login.dart';
import 'package:desktop_im/pages/welcome/welcome_page.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // 应用入口
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 打印token
    String token = UserManager.getInstance().userToken();
    if (kDebugMode) {
      print("token = $token");
    }
    if (token.isNotEmpty) {
      LoginService.autoLogin(token, Callback(
        successCallback: () {
          // setState(() {});
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Routers().addPageRouter("/home_tab", (p0) => const HomePage(), context);
    Routers().addPageRouter("/login_page", (p0) => const LoginPage(), context);
    Routers().registerRouter("/home", (params, context) {
      Navigator.pushReplacementNamed(context, "/home_tab");
    });
    Routers().registerRouter("/login", (params, context) {
      Navigator.pushReplacementNamed(context, "/login_page");
    });
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
          } else {
            // zh-Hans：语言限制匹配规范，表示简体中文
            return const Locale('zh', 'CN'); //简体
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
}

Future<User> getUser() async {
  User user = User();
  await user.restore();
  return user;
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
