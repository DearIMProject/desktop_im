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
      userId: fields[0] as int,
      token: fields[1] as String,
      username: fields[2] as String,
      email: fields[3] as String,
      password: fields[4] as String,
      expireTime: fields[5] as int,
      status: fields[6] as int,
      vipStatus: fields[7] as int,
      vipExpired: fields[8] as String,
      os: fields[9] as String,
      registerTime: fields[10] as int,
      icon: fields[11] as String,
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
      userId: json['userId'] as int,
      token: json['token'] ?? "",
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      expireTime: json['expireTime'] as int,
      status: json['status'] as int,
      vipStatus: json['vipStatus'] as int,
      vipExpired: json['vipExpired'] ?? "",
      os: json['os'] ?? "",
      registerTime: json['registerTime'] as int,
      icon: json['icon'] as String,
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
    };
