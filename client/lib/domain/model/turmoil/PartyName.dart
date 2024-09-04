import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum PartyName {
  MARS,
  SCIENTISTS,
  UNITY,
  KELVINISTS,
  REDS,
  GREENS,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    MARS: 'Mars First',
    SCIENTISTS: 'Scientists',
    UNITY: 'Unity',
    KELVINISTS: 'Kelvinists',
    REDS: 'Reds',
    GREENS: 'Greens',
    UNKNOWN: 'Unknown',
  };
  static final _TO_COLOR_MAP = {
    MARS: Color.fromARGB(246, 214, 97, 55),
    SCIENTISTS: Colors.white,
    UNITY: Colors.blue,
    KELVINISTS: Colors.grey.shade800,
    REDS: Colors.red,
    GREENS: Colors.green,
    UNKNOWN: null,
  };
  Color? toColor() => _TO_COLOR_MAP[this];
  static final _TO_IMAGE_PATH_MAP = {
    MARS: Assets.parties.marsFirst.path,
    SCIENTISTS: Assets.parties.scientists.path,
    UNITY: Assets.parties.unity.path,
    KELVINISTS: Assets.parties.kelvinists.path,
    REDS: Assets.parties.reds.path,
    GREENS: Assets.parties.greens.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
