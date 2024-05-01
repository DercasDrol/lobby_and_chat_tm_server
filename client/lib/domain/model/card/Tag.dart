import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum Tag {
  BUILDING,
  SPACE,
  SCIENCE,
  POWER,
  EARTH,
  JOVIAN,
  VENUS,
  PLANT,
  MICROBE,
  ANIMAL,
  CITY,
  MOON,
  MARS,
  WILD,
  EVENT,
  CLONE;

  static const _TO_STRING_MAP = {
    BUILDING: 'building',
    SPACE: 'space',
    SCIENCE: 'science',
    POWER: 'power',
    EARTH: 'earth',
    JOVIAN: 'jovian',
    VENUS: 'venus',
    PLANT: 'plant',
    MICROBE: 'microbe',
    ANIMAL: 'animal',
    CITY: 'city',
    MOON: 'moon',
    MARS: 'mars',
    WILD: 'wild',
    EVENT: 'event',
    CLONE: 'clone',
  };
  static final _TO_IMAGE_PATH_MAP = {
    BUILDING: Assets.tags.building.path,
    SPACE: Assets.tags.space.path,
    SCIENCE: Assets.tags.science.path,
    POWER: Assets.tags.power.path,
    EARTH: Assets.tags.earth.path,
    JOVIAN: Assets.tags.jovian.path,
    VENUS: Assets.tags.venus.path,
    PLANT: Assets.tags.plant.path,
    MICROBE: Assets.tags.microbe.path,
    ANIMAL: Assets.tags.animal.path,
    CITY: Assets.tags.city.path,
    MOON: Assets.tags.moon.path,
    MARS: Assets.tags.mars.path,
    WILD: Assets.tags.wild.path,
    EVENT: Assets.tags.event.path,
    CLONE: Assets.tags.clone.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this]!;
  static fromString(String value) => _TO_ENUM_MAP[value];

  static fromJson(String value) {
    return fromString(value);
  }

  String toJson() {
    return toString();
  }
}
