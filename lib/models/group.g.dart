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
      contentUserIds: (fields[2] as List).cast<int>(),
      ownUserId: fields[3] as int,
      managerUserIds: (fields[4] as List).cast<int>(),
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
      ..write(obj.contentUserIds)
      ..writeByte(3)
      ..write(obj.ownUserId)
      ..writeByte(4)
      ..write(obj.managerUserIds);
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
      contentUserIds: (json['contentUserIds'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      ownUserId: json['ownUserId'] as int,
      managerUserIds: (json['managerUserIds'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'name': instance.name,
      'contentUserIds': instance.contentUserIds,
      'ownUserId': instance.ownUserId,
      'managerUserIds': instance.managerUserIds,
    };
