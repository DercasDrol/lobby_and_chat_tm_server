// copy from https://github.com/hiranthaR/string_to_color
import 'dart:ui';

class ColorUtils {
  static int _hash(String value) {
    int hash = 0;
    value.runes.forEach((code) {
      hash = code + ((hash << 5) - hash);
    });
    return hash;
  }

  static Color stringToColor(String value) {
    return Color(stringToHexInt(value));
  }

  static String stringToHexColor(String value) {
    String c = (_hash(value) & 0x00FFFFFF).toRadixString(16).toUpperCase();
    return "0xFF00000".substring(0, 10 - c.length) + c;
  }

  static int stringToHexInt(String value) {
    String c = (_hash(value) & 0x00FFFFFF).toRadixString(16).toUpperCase();
    String hex = "FF00000".substring(0, 8 - c.length) + c;
    return int.parse(hex, radix: 16);
  }

  ColorUtils._(); // private constructor
}
