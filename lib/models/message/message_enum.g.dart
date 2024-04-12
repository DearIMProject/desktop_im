// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 3;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.TEXT;
      case 1:
        return MessageType.PICTURE;
      case 2:
        return MessageType.FILE;
      case 3:
        return MessageType.LINK;
      case 4:
        return MessageType.CHAT_MESSAGE;
      case 5:
        return MessageType.REQUEST_LOGIN;
      case 6:
        return MessageType.HEART_BEAT;
      case 7:
        return MessageType.REQUEST_OFFLINE_MESSAGES;
      case 8:
        return MessageType.READED_MESSAGE;
      case 9:
        return MessageType.SEND_SUCCESS_MESSAGE;
      case 10:
        return MessageType.TRANSPARENT_MESSAGE;
      case 11:
        return MessageType.DELETE_MESSAGE;
      case 12:
        return MessageType.DELETE_RECALL;
      case 13:
        return MessageType.GROUP_ADD;
      case 14:
        return MessageType.GROUP_UPDATE;
      case 15:
        return MessageType.GROUP_DELETE;
      default:
        return MessageType.TEXT;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.TEXT:
        writer.writeByte(0);
        break;
      case MessageType.PICTURE:
        writer.writeByte(1);
        break;
      case MessageType.FILE:
        writer.writeByte(2);
        break;
      case MessageType.LINK:
        writer.writeByte(3);
        break;
      case MessageType.CHAT_MESSAGE:
        writer.writeByte(4);
        break;
      case MessageType.REQUEST_LOGIN:
        writer.writeByte(5);
        break;
      case MessageType.HEART_BEAT:
        writer.writeByte(6);
        break;
      case MessageType.REQUEST_OFFLINE_MESSAGES:
        writer.writeByte(7);
        break;
      case MessageType.READED_MESSAGE:
        writer.writeByte(8);
        break;
      case MessageType.SEND_SUCCESS_MESSAGE:
        writer.writeByte(9);
        break;
      case MessageType.TRANSPARENT_MESSAGE:
        writer.writeByte(10);
        break;
      case MessageType.DELETE_MESSAGE:
        writer.writeByte(11);
        break;
      case MessageType.DELETE_RECALL:
        writer.writeByte(12);
        break;
      case MessageType.GROUP_ADD:
        writer.writeByte(13);
        break;
      case MessageType.GROUP_UPDATE:
        writer.writeByte(14);
        break;
      case MessageType.GROUP_DELETE:
        writer.writeByte(15);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageStatusAdapter extends TypeAdapter<MessageStatus> {
  @override
  final int typeId = 4;

  @override
  MessageStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageStatus.STATUS_SUCCESS_UNREADED;
      case 1:
        return MessageStatus.STATUS_SUCCESS_READED;
      case 2:
        return MessageStatus.STATUS_NOT_SEND_UNREAD;
      case 3:
        return MessageStatus.STATUS_DELETE;
      case 4:
        return MessageStatus.STATUS_RECALL;
      default:
        return MessageStatus.STATUS_SUCCESS_UNREADED;
    }
  }

  @override
  void write(BinaryWriter writer, MessageStatus obj) {
    switch (obj) {
      case MessageStatus.STATUS_SUCCESS_UNREADED:
        writer.writeByte(0);
        break;
      case MessageStatus.STATUS_SUCCESS_READED:
        writer.writeByte(1);
        break;
      case MessageStatus.STATUS_NOT_SEND_UNREAD:
        writer.writeByte(2);
        break;
      case MessageStatus.STATUS_DELETE:
        writer.writeByte(3);
        break;
      case MessageStatus.STATUS_RECALL:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageEntityTypeAdapter extends TypeAdapter<MessageEntityType> {
  @override
  final int typeId = 5;

  @override
  MessageEntityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageEntityType.USER;
      case 1:
        return MessageEntityType.GROUP;
      case 2:
        return MessageEntityType.SERVER;
      default:
        return MessageEntityType.USER;
    }
  }

  @override
  void write(BinaryWriter writer, MessageEntityType obj) {
    switch (obj) {
      case MessageEntityType.USER:
        writer.writeByte(0);
        break;
      case MessageEntityType.GROUP:
        writer.writeByte(1);
        break;
      case MessageEntityType.SERVER:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageEntityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageSendStatusAdapter extends TypeAdapter<MessageSendStatus> {
  @override
  final int typeId = 6;

  @override
  MessageSendStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageSendStatus.STATUS_SEND_ING;
      case 1:
        return MessageSendStatus.STATUS_SEND_SUCCESS;
      case 2:
        return MessageSendStatus.STATUS_SEND_FAILURE;
      default:
        return MessageSendStatus.STATUS_SEND_ING;
    }
  }

  @override
  void write(BinaryWriter writer, MessageSendStatus obj) {
    switch (obj) {
      case MessageSendStatus.STATUS_SEND_ING:
        writer.writeByte(0);
        break;
      case MessageSendStatus.STATUS_SEND_SUCCESS:
        writer.writeByte(1);
        break;
      case MessageSendStatus.STATUS_SEND_FAILURE:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSendStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
