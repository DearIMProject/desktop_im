import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fileBean.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class FileBean extends HiveObject {
  FileBean(
      {required this.fileId,
      required this.filePath,
      required this.fileMd5,
      required this.width,
      required this.height});

  @HiveField(0)
  int fileId;
  @HiveField(1)
  String filePath;
  @HiveField(2)
  String fileMd5;
  @HiveField(3)
  int width;
  @HiveField(4)
  int height;

  factory FileBean.fromJson(Map<String, dynamic> json) =>
      _$FileBeanFromJson(json);
  Map<String, dynamic> toJson() => _$FileBeanToJson(this);

  @override
  String toString() {
    return 'FileBean{fileId=$fileId, filePath=$filePath, fileMd5=$fileMd5, width=$width, height=$height}';
  }
}
