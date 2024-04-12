// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileBean.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileBeanAdapter extends TypeAdapter<FileBean> {
  @override
  final int typeId = 4;

  @override
  FileBean read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileBean(
      fileId: fields[0] as int,
      filePath: fields[1] as String,
      fileMd5: fields[2] as String,
      width: fields[3] as int,
      height: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FileBean obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fileId)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.fileMd5)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileBeanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileBean _$FileBeanFromJson(Map<String, dynamic> json) => FileBean(
      fileId: json['fileId'] as int,
      filePath: json['filePath'] as String,
      fileMd5: json['fileMd5'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );

Map<String, dynamic> _$FileBeanToJson(FileBean instance) => <String, dynamic>{
      'fileId': instance.fileId,
      'filePath': instance.filePath,
      'fileMd5': instance.fileMd5,
      'width': instance.width,
      'height': instance.height,
    };
