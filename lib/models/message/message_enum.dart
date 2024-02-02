// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
part 'message_enum.g.dart';

@HiveType(typeId: 3)
enum MessageType {
  @HiveField(0)
  TEXT, //(0, "文本"),
  @HiveField(1)
  PICTURE, //(1, "图片"),
  @HiveField(2)
  FILE, //(2, "文件"),
  @HiveField(3)
  LINK, //(3, "连接"),
  @HiveField(4)
  CHAT_MESSAGE, //(4, "聊天消息列表"),
  @HiveField(5)
  REQUEST_LOGIN, //(5, "请求登录"),
  @HiveField(6)
  HEART_BEAT, //(6, "心跳"),
  @HiveField(7)
  REQUEST_OFFLINE_MESSAGES, //(7, "请求离线消息"),
  @HiveField(8)
  READED_MESSAGE, //(8, "已读消息"),
  @HiveField(9)
  SEND_SUCCESS_MESSAGE, //(9, "发送成功"),
  @HiveField(10)
  TRANSPARENT_MESSAGE, //(10, "透传消息");
}

MessageType intToMessageType(int index) {
  return MessageType.values[index];
}

@HiveType(typeId: 4)
enum MessageStatus {
  @HiveField(0)
  STATUS_SUCCESS_UNREADED, //(0, "发送成功且未读"),
  @HiveField(1)
  STATUS_SUCCESS_READED, //(1, "发送成功且已读"),
  @HiveField(2)
  STATUS_NOT_SEND_UNREAD, //(2, "未发送");
}

MessageStatus intToMessageStatus(int index) {
  return MessageStatus.values[index];
}

@HiveType(typeId: 5)
enum MessageEntityType {
  @HiveField(0)
  USER, //(0, "用户"),
  /*消息群*/
  @HiveField(1)
  GROUP, //(1, "群"),
  @HiveField(2)
  SERVER, //(2, "服务");
}

MessageEntityType intToMessageEntityType(int index) {
  return MessageEntityType.values[index];
}
