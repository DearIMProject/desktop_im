import 'package:desktop_im/user/user.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static UserManager? _instance;
  User? _user;
  static UserManager? getInstance() {
    // ignore: prefer_conditional_assignment
    if (_instance == null) {
      _instance = UserManager();
      _instance!._user = User();
    }
    return _instance;
  }

  Future<void> setUser(User user) async {
    _user = user;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", user.token);
  }

  String userToken() {
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
