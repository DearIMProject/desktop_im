import 'dart:async';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
// user.g.dart 将在我们运行生成命令后自动生成 flutter packages pub run build_runner build
part 'user.g.dart'; // 为适配器生成的代码

const String _kMyUser = "kMyUser";

@JsonSerializable() //这个标注是告诉生成器，这个类是需要生成Model类的
@HiveType(typeId: 1)
class User extends HiveObject {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Box<User>? _userBox;
  Future<Box<User>?> get userBox async {
    if (_userBox == null || !_userBox!.isOpen) {
      // Hive.registerAdapter(UserAdapter());
      _userBox = await Hive.openBox(_kMyUser);
    }
    return _userBox;
  }

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

  User({
    required this.userId,
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
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  Future<void> saveUser() async {
    userBox.then((value) => value?.put(_kMyUser, this));
  }

  Future<bool> restore() async {
    var completer = Completer<bool>();
    userBox.then((value) {
      User? user = value?.get(_kMyUser);
      if (user != null) {
        Log.debug("user is not null user = $user");
        UserManager.getInstance().setUser(user);
        return completer.complete(true);
      }
      Log.debug("user is  null");
      return completer.complete(false);
    });
    return completer.future;
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
  String toString() {
    return 'User{_userBox=$_userBox,\tuserId=$userId,\ttoken=$token,\tusername=$username,\temail=$email,\tpassword=$password,\texpireTime=$expireTime,\tstatus=$status,\tvipStatus=$vipStatus,\tvipExpired=$vipExpired,\tos=$os,\tregisterTime=$registerTime,\ticon=$icon}';
  }
}
