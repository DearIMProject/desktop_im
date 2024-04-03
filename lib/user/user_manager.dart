import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/utils/time_utils.dart';

class UserManager {
  static User _user = User();
  User? get user => _user;

  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  void setUser(User? user) {
    _setUser(user);
  }

  void _setUser(User? user) async {
    if (user != null) {
      _user = user;
    } else {
      _user = User();
    }
    _user.saveUser();
  }

  String userToken() {
    if (_user.token.isNotEmpty) {
      return _user.token;
    }
    return "";
  }

  bool isNotExpire() {
    return isExpire(_user.expireTime);
  }

  int uid() {
    return _user.userId;
  }
}
