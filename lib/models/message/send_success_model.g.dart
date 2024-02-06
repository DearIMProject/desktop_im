// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_success_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendSuccessModel _$SendSuccessModelFromJson(Map<String, dynamic> json) =>
    SendSuccessModel(
      msgId: json['msgId'] as int,
      timestamp: json['timestamp'] as int,
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      content: json['content'] as String,
    );

Map<String, dynamic> _$SendSuccessModelToJson(SendSuccessModel instance) =>
    <String, dynamic>{
      'msgId': instance.msgId,
      'timestamp': instance.timestamp,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'content': instance.content,
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
};
