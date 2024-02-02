import 'package:desktop_im/models/user.dart';

class UserManager {
  static UserManager? _instance;
  static User _user = User();
  User? get user => _user;

  static UserManager getInstance() {
    if (_instance == null) {
      _instance = UserManager();
      _user.restore();
    }
    return _instance!;
  }

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

  int uid() {
    return _user.userId;
  }
}
