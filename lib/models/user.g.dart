// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as int,
      fields[6] as int,
      fields[7] as int,
      fields[10] as int,
      fields[11] as String,
      fields[8] as int,
      fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.expireTime)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.vipStatus)
      ..writeByte(8)
      ..write(obj.vipExpired)
      ..writeByte(9)
      ..write(obj.os)
      ..writeByte(10)
      ..write(obj.registerTime)
      ..writeByte(11)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['userId'] as int? ?? 0,
      json['token'] as String? ?? "",
      json['username'] as String? ?? "",
      json['email'] as String? ?? "",
      json['password'] as String? ?? "",
      json['expireTime'] as int? ?? 0,
      json['status'] as int? ?? 0,
      json['vipStatus'] as int? ?? 0,
      json['registerTime'] as int? ?? 0,
      json['icon'] as String? ?? "",
      json['vipExpired'] as int? ?? 0,
      json['os'] as String? ?? "",
      json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'token': instance.token,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'expireTime': instance.expireTime,
      'status': instance.status,
      'vipStatus': instance.vipStatus,
      'vipExpired': instance.vipExpired,
      'os': instance.os,
      'registerTime': instance.registerTime,
      'icon': instance.icon,
      'isSelected': instance.isSelected,
    };
