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
