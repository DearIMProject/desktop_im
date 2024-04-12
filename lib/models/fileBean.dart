import 'dart:typed_data';

import 'package:desktop_im/utils/file_utils.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

part 'fileBean.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class FileBean extends HiveObject {
  FileBean({
    required this.fileId,
    required this.filePath,
    required this.fileMd5,
    required this.width,
    required this.height,
    // this.bytes,
  });

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

  static Future<FileBean> initFileBean(String filePath) async {
    MultipartFile file =
        await MultipartFile.fromFile(filePath, filename: filePath);
    Tuple4<int, int, String, Uint8List> imageDesc =
        await FileUtils.imageDesc(file);
    return FileBean(
        fileId: 0,
        filePath: filePath,
        fileMd5: imageDesc.item3,
        width: imageDesc.item1,
        height: imageDesc.item2);
  }

  factory FileBean.fromJson(Map<String, dynamic> json) =>
      _$FileBeanFromJson(json);
  Map<String, dynamic> toJson() => _$FileBeanToJson(this);

  @override
  String toString() {
    return 'FileBean{fileId=$fileId, filePath=$filePath, fileMd5=$fileMd5, width=$width, height=$height}';
  }
}
