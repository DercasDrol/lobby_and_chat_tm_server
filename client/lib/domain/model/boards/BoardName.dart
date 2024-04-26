import 'dart:ui';

import 'package:mars_flutter/domain/model/boards/BoardNameType.dart';
import 'package:mars_flutter/domain/model/constants.dart';

enum BoardName implements BoardNameType {
  THARSIS,
  HELLAS,
  ELYSIUM,
  UTOPIA_PLANITIA,
  VASTITAS_BOREALIS_NOVUS,
  ARABIA_TERRA,
  VASTITAS_BOREALIS,
  AMAZONIS,
  TERRA_CIMMERIA;

  static const _TO_STRING_MAP = {
    THARSIS: 'tharsis',
    HELLAS: 'hellas',
    ELYSIUM: 'elysium',
    UTOPIA_PLANITIA: 'utopia planitia',
    VASTITAS_BOREALIS_NOVUS: 'vastitas borealis novus',
    ARABIA_TERRA: 'arabia terra',
    VASTITAS_BOREALIS: 'vastitas borealis',
    AMAZONIS: 'amazonis p.',
    TERRA_CIMMERIA: 't. cimmeria',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];

  static const _BOARD_NAME_NAME = {
    THARSIS: 'Tharsis',
    HELLAS: 'Hellas',
    ELYSIUM: 'Elysium',
    UTOPIA_PLANITIA: 'Utopia Planitia',
    VASTITAS_BOREALIS_NOVUS: 'Vastitas Borealis Novus',
    ARABIA_TERRA: 'Arabia Terra',
    VASTITAS_BOREALIS: 'Vastitas Borealis',
    AMAZONIS: 'Amazonis Planitia',
    TERRA_CIMMERIA: 'Terra Cimmeria',
  };

  String get name {
    return _BOARD_NAME_NAME[this] ?? this.toString();
  }

  static const _BOARD_SHORT_NAME = {
    THARSIS: 'Tharsis',
    HELLAS: 'Hellas',
    ELYSIUM: 'Elysium',
    UTOPIA_PLANITIA: 'Utopia P.',
    VASTITAS_BOREALIS_NOVUS: 'Vastitas B. N.',
    ARABIA_TERRA: 'Arabia T.',
    VASTITAS_BOREALIS: 'Vastitas B.',
    AMAZONIS: 'Amazonis P.',
    TERRA_CIMMERIA: 'T. Cimmeria',
  };
  @override
  String get shortName {
    return _BOARD_SHORT_NAME[this] ?? this.toString();
  }

  @override
  String? get descriptionUrl {
    switch (this) {
      case THARSIS:
        return THARSIS_DESCRIPTION_URL;
      case HELLAS:
        return HELLAS_DESCRIPTION_URL;
      case ELYSIUM:
        return ELYSIUM_DESCRIPTION_URL;
      case UTOPIA_PLANITIA:
        return UTOPIA_PLANITIA_DESCRIPTION_URL;
      case VASTITAS_BOREALIS_NOVUS:
        return VASTITAS_BOREALIS_NOVUS_DESCRIPTION_URL;
      case ARABIA_TERRA:
        return ARABIA_TERRA_DESCRIPTION_URL;
      case VASTITAS_BOREALIS:
        return VASTITAS_BOREALIS_DESCRIPTION_URL;
      case AMAZONIS:
        return AMAZONIS_DESCRIPTION_URL;
      case TERRA_CIMMERIA:
        return TERRA_CIMMERIA_DESCRIPTION_URL;
    }
  }

  @override
  Color get color {
    switch (this) {
      case THARSIS:
        return Color.fromARGB(255, 224, 153, 109);
      case HELLAS:
        return Color.fromARGB(255, 55, 111, 156);
      case ELYSIUM:
        return Color.fromARGB(255, 31, 121, 32);
      case UTOPIA_PLANITIA:
        return Color.fromARGB(255, 255, 255, 255);
      case VASTITAS_BOREALIS_NOVUS:
        return Color.fromARGB(255, 255, 255, 255);
      case ARABIA_TERRA:
        return Color.fromARGB(255, 116, 77, 160);
      case VASTITAS_BOREALIS:
        return Color.fromARGB(255, 177, 163, 40);
      case AMAZONIS:
        return Color.fromARGB(255, 87, 172, 9);
      case TERRA_CIMMERIA:
        return Color.fromARGB(255, 186, 0, 134);
    }
  }
}
