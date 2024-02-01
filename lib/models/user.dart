import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
// ignore: depend_on_referenced_packages
// part 'User.g.dart'; // 为适配器生成的代码

const String _kMyUser = "kMyUser";

@JsonSerializable()
@HiveType(typeId: 1)
class User implements HiveObject {
  Box<User>? userBox;
  @HiveField(0)
  int userId = 0;
  @HiveField(1)
  String token = "";

  @HiveField(2)
  String username = "";
  @HiveField(3)
  String email = "";

  @HiveField(4)
  String password = "";
  @HiveField(5)
  int expireTime = 0;
  @HiveField(6)
  int status = 0;
  @HiveField(7)
  int vipStatus = 0;
  @HiveField(8)
  String vipExpired = "";
  @HiveField(9)
  String os = "";
  @HiveField(10)
  int registerTime = 0;
  @HiveField(11)
  String icon = "";

  User(
      {required this.userId,
      required this.token,
      required this.username,
      required this.email,
      required this.password,
      required this.expireTime,
      required this.status,
      required this.vipStatus,
      required this.vipExpired,
      required this.os,
      required this.registerTime,
      required this.icon,
      this.userBox});

  static User fromJson(Map<String, dynamic> json) {
    String token = json["token"] ?? "";
    int expireTime = json["expireTime"];
    String username = json["username"];
    int userId = json["userId"];
    String email = json["email"];
    String password = json["password"];
    int status = json["status"];
    int vipStatus = json["vipStatus"];
    String vipExpired = json["vipExpired"] ?? "";
    String os = json["os"] ?? "";
    int registerTime = json["registerTime"];
    String icon = json["icon"];
    return User(
        userId: userId,
        token: token,
        username: username,
        email: email,
        password: password,
        expireTime: expireTime,
        status: status,
        vipStatus: vipStatus,
        vipExpired: vipExpired,
        os: os,
        registerTime: registerTime,
        icon: icon);
  }

  Future<void> saveUser() async {
    Map<String, dynamic> json = <String, dynamic>{};
    json["token"] = token;
    json["expireTime"] = expireTime;
    json["username"] = username;
    json["userId"] = userId;
    json["email"] = email;
    json["password"] = password;
    json["status"] = status;
    json["vipStatus"] = vipStatus;
    json["vipExpired"] = vipExpired;
    json["os"] = os;
    json["registerTime"] = registerTime;
    json["icon"] = icon;
    userBox ??= await Hive.openBox<User>(_kMyUser);
    userBox!.put(_kMyUser, this);
  }

  Future<bool> restore() async {
    userBox ??= await Hive.openBox<User>(_kMyUser);
    User? user = userBox!.get(_kMyUser);
    if (user != null) {
      Log.debug("user is not null user = $user");
      UserManager.getInstance().setUser(user);
      return true;
    }
    Log.debug("user is  null");
    return false;
  }

  /// 登录
  void login(
    String username,
    String password,
    Callback callback,
  ) {
    LoginService.login(
        username,
        password,
        Callback(
            successCallback: () {
              if (callback.successCallback != null) {
                callback.successCallback!();
              }
            },
            failureCallback: callback.failureCallback));
  }

  /// 自动登录
  Future<void> autologin(Callback callback) async {
    LoginService.autoLogin(
        token,
        Callback(
            successCallback: () {
              if (callback.successCallback != null) {
                callback.successCallback!();
              }
            },
            failureCallback: callback.failureCallback));
  }

  /// 登出
  void logout(String token, Callback callback) {
    LoginService.logout(
      token,
      Callback(
          successCallback: () {
            if (callback.successCallback != null) {
              callback.successCallback!();
            }
          },
          failureCallback: callback.failureCallback),
    );
  }

  @override
  // TODO: implement box
  BoxBase? get box => throw UnimplementedError();

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  // TODO: implement isInBox
  bool get isInBox => throw UnimplementedError();

  @override
  // TODO: implement key
  get key => throw UnimplementedError();

  @override
  Future<void> save() {
    // TODO: implement save
    throw UnimplementedError();
  }
}
