import 'package:desktop_im/models/message/chat_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'group.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class Group extends HiveObject with ChatEntity {
  Group(
      {required this.groupId,
      required this.name,
      required this.userIds,
      required this.ownUserId,
      required this.mUserIds});

  @HiveField(0)
  @JsonValue(0)
  int groupId = 0;

  @HiveField(1)
  @JsonValue(1)
  String name = "";

  @HiveField(2)
  @JsonValue(2)
  String userIds = "";

  @HiveField(3)
  @JsonValue(3)
  int ownUserId = 0;

  @HiveField(4)
  @JsonValue(4)
  String mUserIds = "";

  @override
  String toString() {
    return 'Group{groupId=$groupId, name=$name, userIds=$userIds, ownUserId=$ownUserId, mUserIds=$mUserIds}';
  }

  @override
  String getIconUrl() {
    //TODO: wmy 图片
    return "";
  }

  @override
  String getName() {
    return name;
  }

  @override
  String getKey() {
    return "${groupId}_1";
  }
}
