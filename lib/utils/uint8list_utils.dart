import 'dart:convert';
import 'dart:typed_data';

class Uint8ListUtils {
  //Uint8List to string
  static String convertUint8ListToString(Uint8List uint8list) {
    return utf8.decode(uint8list);
    //return String.fromCharCodes(uint8list);
  }

  //string to Uint8List
  static Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = utf8.encode(str);
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  static String intToHex(int value) {
    if (value >= 0 && value < 16) {
      return "0${value.toRadixString(16)}";
    }
    return value.toRadixString(16);
  }
}
