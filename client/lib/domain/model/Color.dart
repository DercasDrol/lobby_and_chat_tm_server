import 'package:flutter/material.dart';

enum PlayerColor {
  BLUE,
  RED,
  YELLOW,
  GREEN,
  BLACK,
  PURPLE,
  ORANGE,
  PINK,
  NEUTRAL,
  BRONZE;

  static const _TO_STRING_MAP = {
    BLUE: 'blue',
    RED: 'red',
    YELLOW: 'yellow',
    GREEN: 'green',
    BLACK: 'black',
    PURPLE: 'purple',
    ORANGE: 'orange',
    PINK: 'pink',
    NEUTRAL: 'neutral',
    BRONZE: 'bronze',
  };
  static const _TO_VIEW_COLOR_MAP = {
    BLUE: Colors.blue,
    RED: Colors.red,
    YELLOW: Colors.yellow,
    GREEN: Colors.green,
    BLACK: Color.fromARGB(255, 50, 50, 50),
    PURPLE: Colors.purple,
    ORANGE: Colors.orange,
    PINK: Colors.pink,
    NEUTRAL: Colors.grey,
    BRONZE: Colors.deepOrange,
  };
  static const _TO_VIEW_COLOR_WITH_OPACITY_MAP = {
    BLUE: Color.fromARGB(230, 33, 149, 243),
    RED: Color.fromARGB(230, 160, 11, 0),
    YELLOW: Color.fromARGB(230, 255, 235, 59),
    GREEN: Color.fromARGB(230, 76, 175, 79),
    BLACK: Color.fromARGB(230, 50, 50, 50),
    PURPLE: Color.fromARGB(230, 155, 39, 176),
    ORANGE: Color.fromARGB(230, 255, 153, 0),
    PINK: Color.fromARGB(230, 233, 30, 98),
    NEUTRAL: Color.fromARGB(230, 158, 158, 158),
    BRONZE: Color.fromARGB(230, 255, 86, 34),
  };
  static const playerColors = [
    BLUE,
    RED,
    YELLOW,
    GREEN,
    BLACK,
    PURPLE,
    ORANGE,
    PINK,
  ];
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  Color toColor(bool useOpacity) => useOpacity
      ? (_TO_VIEW_COLOR_WITH_OPACITY_MAP[this] ?? Colors.white)
      : (_TO_VIEW_COLOR_MAP[this] ?? Colors.white);
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
