// ignore_for_file: constant_identifier_names

enum MessageType {
  TEXT, //(0, "文本"),
  PICTURE, //(1, "图片"),
  FILE, //(2, "文件"),
  LINK, //(3, "连接"),
  CHAT_MESSAGE, //(4, "聊天消息列表"),
  REQUEST_LOGIN, //(5, "请求登录"),
  HEART_BEAT, //(6, "心跳"),
  REQUEST_OFFLINE_MESSAGES, //(7, "请求离线消息"),
  READED_MESSAGE, //(8, "已读消息"),
  SEND_SUCCESS_MESSAGE, //(9, "发送成功"),
  TRANSPARENT_MESSAGE, //(10, "透传消息");
}

MessageType intToMessageType(int index) {
  return MessageType.values[index];
}

enum MessageStatus {
  STATUS_SUCCESS_UNREADED, //(0, "发送成功且未读"),
  STATUS_SUCCESS_READED, //(1, "发送成功且已读"),
  STATUS_NOT_SEND_UNREAD, //(2, "未发送");
}

MessageStatus intToMessageStatus(int index) {
  return MessageStatus.values[index];
}

enum MessageEntityType {
  USER, //(0, "用户"),
  /*消息群*/
  GROUP, //(1, "群"),
  SERVER, //(2, "服务");
}

MessageEntityType intToMessageEntityType(int index) {
  return MessageEntityType.values[index];
}
