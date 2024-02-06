import 'package:desktop_im/models/message/message_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_success_model.g.dart';

@JsonSerializable()
class SendSuccessModel {
  SendSuccessModel(
      {required this.msgId,
      required this.timestamp,
      required this.messageType,
      required this.content});
  int msgId;
  int timestamp;
  MessageType messageType;
  String content;

  factory SendSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$SendSuccessModelFromJson(json);
  Map<String, dynamic> toJson() => _$SendSuccessModelToJson(this);

  // MessageType _messageTypeFromJson(int type) => MessageType.values[type];
  // int _messageTypeToJson(MessageType messageType) => messageType.index;

  @override
  String toString() {
    return 'SendSuccessModel{msgId=$msgId, timestamp=$timestamp, messageType=$messageType, content=$content}';
  }
}
