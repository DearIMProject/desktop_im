// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 2;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      fields[0] as int,
      fields[1] as int,
      fields[2] as MessageEntityType,
      fields[3] as int,
      fields[4] as MessageEntityType,
      fields[5] as String,
      fields[6] as MessageType,
      fields[7] as int,
      fields[8] as MessageStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.msgId)
      ..writeByte(1)
      ..write(obj.fromId)
      ..writeByte(2)
      ..write(obj.fromEntity)
      ..writeByte(3)
      ..write(obj.toId)
      ..writeByte(4)
      ..write(obj.toEntity)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.messageType)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['msgId'] as int? ?? 0,
      json['fromId'] as int? ?? 0,
      $enumDecodeNullable(_$MessageEntityTypeEnumMap, json['fromEntity']) ??
          MessageEntityType.USER,
      json['toId'] as int? ?? 0,
      $enumDecodeNullable(_$MessageEntityTypeEnumMap, json['toEntity']) ??
          MessageEntityType.USER,
      json['content'] as String? ?? "",
      $enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']) ??
          MessageType.TEXT,
      json['timestamp'] as int? ?? 0,
      $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.STATUS_NOT_SEND_UNREAD,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'msgId': instance.msgId,
      'fromId': instance.fromId,
      'fromEntity': _$MessageEntityTypeEnumMap[instance.fromEntity]!,
      'toId': instance.toId,
      'toEntity': _$MessageEntityTypeEnumMap[instance.toEntity]!,
      'content': instance.content,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'timestamp': instance.timestamp,
      'status': _$MessageStatusEnumMap[instance.status]!,
    };

const _$MessageEntityTypeEnumMap = {
  MessageEntityType.USER: 'USER',
  MessageEntityType.GROUP: 'GROUP',
  MessageEntityType.SERVER: 'SERVER',
};

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.PICTURE: 'PICTURE',
  MessageType.FILE: 'FILE',
  MessageType.LINK: 'LINK',
  MessageType.CHAT_MESSAGE: 'CHAT_MESSAGE',
  MessageType.REQUEST_LOGIN: 'REQUEST_LOGIN',
  MessageType.HEART_BEAT: 'HEART_BEAT',
  MessageType.REQUEST_OFFLINE_MESSAGES: 'REQUEST_OFFLINE_MESSAGES',
  MessageType.READED_MESSAGE: 'READED_MESSAGE',
  MessageType.SEND_SUCCESS_MESSAGE: 'SEND_SUCCESS_MESSAGE',
  MessageType.TRANSPARENT_MESSAGE: 'TRANSPARENT_MESSAGE',
};

const _$MessageStatusEnumMap = {
  MessageStatus.STATUS_SUCCESS_UNREADED: 'STATUS_SUCCESS_UNREADED',
  MessageStatus.STATUS_SUCCESS_READED: 'STATUS_SUCCESS_READED',
  MessageStatus.STATUS_NOT_SEND_UNREAD: 'STATUS_NOT_SEND_UNREAD',
};
