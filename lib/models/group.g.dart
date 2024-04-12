// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupAdapter extends TypeAdapter<Group> {
  @override
  final int typeId = 7;

  @override
  Group read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Group(
      groupId: fields[0] as int,
      name: fields[1] as String,
      userIds: fields[2] as String,
      ownUserId: fields[3] as int,
      mUserIds: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Group obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.groupId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.userIds)
      ..writeByte(3)
      ..write(obj.ownUserId)
      ..writeByte(4)
      ..write(obj.mUserIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      groupId: json['groupId'] as int,
      name: json['name'] as String,
      userIds: json['userIds'] as String,
      ownUserId: json['ownUserId'] as int,
      mUserIds: json['mUserIds'] as String,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'name': instance.name,
      'userIds': instance.userIds,
      'ownUserId': instance.ownUserId,
      'mUserIds': instance.mUserIds,
    };
