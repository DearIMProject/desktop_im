import 'package:desktop_im/models/user.dart';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static UserManager? _instance;
  static SharedPreferences? prefs;
  static User _user = User();
  User? get user => _user;

  static UserManager getInstance() {
    if (_instance == null) {
      _instance = UserManager();
      _user.restore();
    }
    return _instance!;
  }

  void setUser(User user) {
    _user = user;
    _setUser(user);
  }

  void _setUser(User user) async {
    _user = user;
    _user.save();
  }

  String userToken() {
    if (_user.token.isNotEmpty) {
      return _user.token;
    }
    return "";
  }

  int uid() {
    return _user.userId;
  }
}
