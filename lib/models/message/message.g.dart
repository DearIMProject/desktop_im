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
      fields[9] as MessageSendStatus,
      fields[11] as int,
      fields[10] as MessageEntityType,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.sendStatue)
      ..writeByte(10)
      ..write(obj.entityType)
      ..writeByte(11)
      ..write(obj.entityId);
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
      $enumDecodeNullable(_$MessageSendStatusEnumMap, json['sendStatue']) ??
          MessageSendStatus.STATUS_SEND_ING,
      json['entityId'] as int? ?? 0,
      $enumDecodeNullable(_$MessageEntityTypeEnumMap, json['entityType']) ??
          MessageEntityType.USER,
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
      'sendStatue': _$MessageSendStatusEnumMap[instance.sendStatue]!,
      'entityType': _$MessageEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
    };

const _$MessageEntityTypeEnumMap = {
  MessageEntityType.USER: 0,
  MessageEntityType.GROUP: 1,
  MessageEntityType.SERVER: 2,
};

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 0,
  MessageType.PICTURE: 1,
  MessageType.FILE: 2,
  MessageType.LINK: 3,
  MessageType.CHAT_MESSAGE: 4,
  MessageType.REQUEST_LOGIN: 5,
  MessageType.HEART_BEAT: 6,
  MessageType.REQUEST_OFFLINE_MESSAGES: 7,
  MessageType.READED_MESSAGE: 8,
  MessageType.SEND_SUCCESS_MESSAGE: 9,
  MessageType.TRANSPARENT_MESSAGE: 10,
  MessageType.DELETE_MESSAGE: 11,
  MessageType.DELETE_RECALL: 12,
  MessageType.GROUP_ADD: 13,
  MessageType.GROUP_UPDATE: 14,
  MessageType.GROUP_DELETE: 15,
  MessageType.LOCAL_TEXT: 100,
};

const _$MessageStatusEnumMap = {
  MessageStatus.STATUS_SUCCESS_UNREADED: 0,
  MessageStatus.STATUS_SUCCESS_READED: 1,
  MessageStatus.STATUS_NOT_SEND_UNREAD: 2,
  MessageStatus.STATUS_DELETE: 3,
  MessageStatus.STATUS_RECALL: 4,
};

const _$MessageSendStatusEnumMap = {
  MessageSendStatus.STATUS_SEND_ING: 0,
  MessageSendStatus.STATUS_SEND_SUCCESS: 1,
  MessageSendStatus.STATUS_SEND_FAILURE: 2,
};
