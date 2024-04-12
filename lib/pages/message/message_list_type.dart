import 'package:json_annotation/json_annotation.dart';

enum MessageListType {
  @JsonValue(0)
  USER,
  @JsonValue(1)
  GROUP,
}
