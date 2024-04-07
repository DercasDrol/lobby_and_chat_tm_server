import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/boards/BoardNameType.dart';

enum RandomBoardOption implements BoardNameType {
  OFFICIAL,
  ALL;

  static const _TO_STRING_MAP = {
    OFFICIAL: 'random official',
    ALL: 'random all',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];

  @override
  String? get descriptionUrl => null;

  @override
  String get name {
    switch (this) {
      case OFFICIAL:
        return 'Random Official';
      case ALL:
        return 'Random All';
    }
  }

  @override
  Color get color => Colors.grey;

  @override
  String get shortName {
    switch (this) {
      case OFFICIAL:
        return 'Random Official';
      case ALL:
        return 'Random All';
    }
  }
}
