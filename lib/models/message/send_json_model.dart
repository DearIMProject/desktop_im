import 'package:desktop_im/models/message/message_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_json_model.g.dart';

@JsonSerializable()
class SendJsonModel {
  SendJsonModel(
      {required this.msgId,
      required this.timestamp,
      this.messageType,
      required this.content});
  int msgId;
  int timestamp;
  MessageType? messageType;
  String content;

  factory SendJsonModel.fromJson(Map<String, dynamic> json) =>
      _$SendJsonModelFromJson(json);
  Map<String, dynamic> toJson() => _$SendJsonModelToJson(this);

  @override
  String toString() {
    return 'SendSuccessModel{msgId=$msgId, timestamp=$timestamp, messageType=$messageType, content=$content}';
  }
}
