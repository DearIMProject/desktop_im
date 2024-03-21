import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FileUtils {
  static Future<Tuple4<int, int, String, Uint8List>> imageDesc(
      MultipartFile file) async {
    // 将Stream<List<int>>转换为Uint8List
    Uint8List bytes = await file.finalize().fold<Uint8List>(Uint8List(0),
        (previous, element) => Uint8List.fromList([...previous, ...element]));

    // 从字节数据创建Image对象
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;
    // 获取图片的宽度和高度
    final int width = image.width;
    final int height = image.height;

    // Convert Uint8List to List<int>
    List<int> dataList = bytes.toList();

    // Calculate MD5 hash
    var md5Hash = md5.convert(dataList);

    // Convert MD5 hash to hex string
    String md5Hex = md5Hash.toString();

    return Tuple4(width, height, md5Hex, bytes);
  }
}
