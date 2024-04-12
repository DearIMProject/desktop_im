// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'message_enum.g.dart';

@HiveType(typeId: 3)
enum MessageType {
  @HiveField(0)
  @JsonValue(0)
  TEXT, //(0, "文本"),
  @HiveField(1)
  @JsonValue(1)
  PICTURE, //(1, "图片"),
  @HiveField(2)
  @JsonValue(2)
  FILE, //(2, "文件"),
  @HiveField(3)
  @JsonValue(3)
  LINK, //(3, "链接"),
  @JsonValue(4)
  @HiveField(4)
  CHAT_MESSAGE, //(4, "聊天消息列表"),
  @JsonValue(5)
  @HiveField(5)
  REQUEST_LOGIN, //(5, "请求登录"),
  @HiveField(6)
  @JsonValue(6)
  HEART_BEAT, //(6, "心跳"),
  @HiveField(7)
  @JsonValue(7)
  REQUEST_OFFLINE_MESSAGES, //(7, "请求离线消息"),
  @HiveField(8)
  @JsonValue(8)
  READED_MESSAGE, //(8, "已读消息"),
  @HiveField(9)
  @JsonValue(9)
  SEND_SUCCESS_MESSAGE, //(9, "发送成功"),
  @HiveField(10)
  @JsonValue(10)
  TRANSPARENT_MESSAGE, //(10, "透传消息");
  @HiveField(11)
  @JsonValue(11)
  DELETE_MESSAGE, // (11,"删除消息")
  @HiveField(12)
  @JsonValue(12)
  DELETE_RECALL, // (12,"删除消息")
  @HiveField(13)
  @JsonValue(13)
  GROUP_ADD, // (13, "群组添加")
  @HiveField(14)
  @JsonValue(14)
  GROUP_UPDATE, // (14, "群组更新")
  @HiveField(15)
  @JsonValue(15)
  GROUP_DELETE, // (15, "群组删除")
}

MessageType intToMessageType(int index) {
  return MessageType.values[index];
}

@HiveType(typeId: 4)
enum MessageStatus {
  @HiveField(0)
  @JsonValue(0)
  STATUS_SUCCESS_UNREADED, //(0, "发送成功且未读"),
  @HiveField(1)
  @JsonValue(1)
  STATUS_SUCCESS_READED, //(1, "发送成功且已读"),
  @HiveField(2)
  @JsonValue(2)
  STATUS_NOT_SEND_UNREAD, //(2, "未发送");
  @HiveField(3)
  @JsonValue(3)
  STATUS_DELETE, //(3, "删除");
  @HiveField(4)
  @JsonValue(4)
  STATUS_RECALL, //(4, "撤回");
}

MessageStatus intToMessageStatus(int index) {
  return MessageStatus.values[index];
}

@HiveType(typeId: 5)
enum MessageEntityType {
  @HiveField(0)
  @JsonValue(0)
  USER, //(0, "用户"),
  /*消息群*/
  @HiveField(1)
  @JsonValue(1)
  GROUP, //(1, "群"),
  @HiveField(2)
  @JsonValue(2)
  SERVER, //(2, "服务");
}

MessageEntityType intToMessageEntityType(int index) {
  return MessageEntityType.values[index];
}

@HiveType(typeId: 6)
enum MessageSendStatus {
  @HiveField(0)
  @JsonValue(0)
  STATUS_SEND_ING, // 发送中
  @HiveField(1)
  @JsonValue(1)
  STATUS_SEND_SUCCESS, // 发送成功
  @HiveField(2)
  @JsonValue(2)
  STATUS_SEND_FAILURE, // 发送失败
}
