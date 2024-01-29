import 'dart:convert';

import 'package:desktop_im/user/login_service.dart';
import 'package:desktop_im/user/user_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class User {
  SharedPreferences? prefs;
  static const String _user_key = "_user";
  String token = "";
  int expireTime = 0;
  String username = "";
  int userId = 0;
  String email = "";
  String password = "";
  int status = 0;
  int vipStatus = 0;
  String vipExpired = "";
  String os = "";
  int registerTime = 0;
  String icon = "";

  User();

  User fromJson(Map<String, dynamic> json) {
    token = json["token"];
    expireTime = json["expireTime"];
    username = json["username"];
    userId = json["userId"];
    userId = json["userId"];
    email = json["email"];
    password = json["password"];
    status = json["status"];
    vipStatus = json["vipStatus"];
    vipExpired = json["vipExpired"] ?? "";
    os = json["os"] ?? "";
    registerTime = json["registerTime"];
    icon = json["icon"];
    return this;
  }

  Future<int> save(Map<String, dynamic> json) async {
    if (userId <= 0 || token.isEmpty) {
      return Future.value(-1);
    }
    prefs ??= await SharedPreferences.getInstance();
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
    prefs!.setString(_user_key, jsonEncode(json));
    return Future.value(0);
  }

  Future<bool> restore() async {
    prefs ??= await SharedPreferences.getInstance();
    String? jsonStr = prefs!.getString(_user_key);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      fromJson(jsonDecode(jsonStr));
      UserManager.getInstance().setUser(this);
      return Future.value(true);
    }
    return Future.value(false);
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
    prefs ??= await SharedPreferences.getInstance();

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
}
