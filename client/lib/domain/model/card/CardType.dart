import 'package:flutter/material.dart';

enum CardType {
  EVENT,
  ACTIVE,
  AUTOMATED,
  PRELUDE,
  CORPORATION,
  CEO,
  STANDARD_PROJECT,
  STANDARD_ACTION,
  PROXY;

  static const _TO_STRING_MAP = {
    EVENT: 'event',
    ACTIVE: 'active',
    AUTOMATED: 'automated',
    PRELUDE: 'prelude',
    CORPORATION: 'corporation',
    CEO: 'ceo',
    STANDARD_PROJECT: 'standard_project',
    STANDARD_ACTION: 'standard_action',
    // Proxy cards are not real cards, but for operations that need a card-like behavior.
    PROXY: 'proxy',
  };
  static final _TO_COLOR_MAP = {
    EVENT: Color.fromARGB(255, 241, 140, 24),
    ACTIVE: Colors.blue[400],
    AUTOMATED: Colors.green[500],
    PRELUDE: Colors.pink[300],
    CORPORATION: Colors.white,
    CEO: Colors.white,
    STANDARD_PROJECT: Colors.white,
    STANDARD_ACTION: Colors.grey,
    PROXY: Colors.white,
  };
  Color? toColor() => _TO_COLOR_MAP[this];
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value];

  static CardType fromJson(String value) {
    try {
      return _TO_ENUM_MAP[value]!;
    } catch (e) {
      throw ('CardType.fromJson: $value', e);
    }
  }

  String toJson() => toString();
}
