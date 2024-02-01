import 'package:desktop_im/models/user.dart';

class UserManager {
  static UserManager? _instance;
  static User _user = User(
      userId: 0,
      token: "",
      username: "",
      email: "",
      password: "",
      expireTime: 0,
      status: 0,
      vipStatus: 0,
      vipExpired: "",
      os: "os",
      registerTime: 0,
      icon: "");
  User? get user => _user;

  static UserManager getInstance() {
    if (_instance == null) {
      _instance = UserManager();
      _user.restore();
    }
    return _instance!;
  }

  void setUser(User? user) {
    if (user != null) {
      _setUser(user);
      _user = user;
    } else {
      _user = User(
          userId: 0,
          token: "",
          username: "",
          email: "",
          password: "",
          expireTime: 0,
          status: 0,
          vipStatus: 0,
          vipExpired: "",
          os: "os",
          registerTime: 0,
          icon: "");
    }
  }

  void _setUser(User user) async {
    _user = user;
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
