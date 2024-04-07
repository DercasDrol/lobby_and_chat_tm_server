import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum Resource {
  MEGACREDITS,
  STEEL,
  TITANIUM,
  PLANTS,
  ENERGY,
  HEAT,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    MEGACREDITS: 'megacredits',
    STEEL: 'steel',
    TITANIUM: 'titanium',
    PLANTS: 'plants',
    ENERGY: 'energy',
    HEAT: 'heat'
  };

  static const ALL_RESOURCES = [
    MEGACREDITS,
    STEEL,
    TITANIUM,
    PLANTS,
    ENERGY,
    HEAT,
  ];
  static final _TO_IMAGE_PATH_MAP = {
    MEGACREDITS: Assets.resources.megacredit.path,
    STEEL: Assets.resources.steel.path,
    TITANIUM: Assets.resources.titanium.path,
    PLANTS: Assets.resources.plant.path,
    ENERGY: Assets.resources.power.path,
    HEAT: Assets.resources.heat.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
