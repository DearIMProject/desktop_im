class User {
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

  User.fromJson(Map<String, dynamic> json) {
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
  }

  // User fromJson(Map<String, dynamic> json) {}
}
