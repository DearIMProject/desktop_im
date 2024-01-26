import 'package:desktop_im/user/user.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static UserManager? _instance;
  User? _user;
  String _token = "";
  static String TOKEN = "token";
  static UserManager getInstance() {
    if (_instance == null) {
      _instance = UserManager();
      _initToken();
    }
    return _instance!;
  }

  static void _initToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? atoken = prefs.getString(TOKEN);
    if (atoken != null) {
      _instance!._token = atoken;
    } else {
      _instance!._token = "";
    }
  }

  void setUser(User user) {
    _user = user;
    _setUser(user);
  }

  Future<void> _setUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TOKEN, user.token);
  }

  String userToken() {
    if (_token.isNotEmpty) {
      return _token;
    }
    if (_user != null && _user!.token.isNotEmpty) {
      return _user!.token;
    }
    return "";
  }

  int uid() {
    if (_user != null && _user!.userId != 0) {
      return _user!.userId;
    }
    return 0;
  }
}
