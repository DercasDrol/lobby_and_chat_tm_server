// There might be a temptation to rename or reorder these, but SpaceBonus is stored in the database
// as its number. Would have been better if this was stored as a string, but that ship has sailed,
// for now.

import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum SpaceBonus {
  TITANIUM, // 0
  STEEL, // 1
  PLANT, // 2
  DRAW_CARD, // 3
  HEAT, // 4
  OCEAN, // 5

  // Ares-specific
  MEGACREDITS, // 6
  ANIMAL, // 7 (Also used in Amazonis)
  MICROBE, // 8 (Also used in Arabia Terra)
  ENERGY, // 9 // Ares and Terra Cimmeria

  // Arabia Terra-specific
  DATA, // 10
  SCIENCE, // 11
  ENERGY_PRODUCTION, // 12

  // Vastitas Borealis-specific
  TEMPERATURE, // 13
  // Amazonis-specific
  // TODO(kberg): move RESTRICTED to SpaceType?
  RESTRICTED, // 14  // RESTRICTED is just a that a space is empty, not an actual bonus.
  ASTEROID; // 15 // Used by Deimos Down Ares

  static const _TO_STRING_MAP = {
    TITANIUM: 'Titanium',
    STEEL: 'Steel',
    PLANT: 'Plant',
    DRAW_CARD: 'Card',
    HEAT: 'Heat',
    OCEAN: 'Ocean',
    MEGACREDITS: 'M€',
    ANIMAL: 'Animal',
    MICROBE: 'Microbe',
    ENERGY: 'Energy',
    DATA: 'Data',
    SCIENCE: 'Science',
    ENERGY_PRODUCTION: 'Energy Production',
    TEMPERATURE: 'Temperature',
    RESTRICTED: 'Restricted',
    ASTEROID: 'Asteroid',
  };
  static final _TO_IMAGE_PATH_MAP = {
    TITANIUM: Assets.resources.titanium.path,
    STEEL: Assets.resources.steel.path,
    PLANT: Assets.resources.plant.path,
    DRAW_CARD: Assets.resources.card.path,
    HEAT: Assets.resources.heat.path,
    OCEAN: Assets.tiles.ocean.path,
    MEGACREDITS: Assets.resources.megacredit.path,
    ANIMAL: Assets.resources.animal.path,
    MICROBE: Assets.resources.microbe.path,
    ENERGY: Assets.resources.power.path,
    DATA: Assets.resources.data.path,
    SCIENCE: Assets.resources.science.path,
    ENERGY_PRODUCTION: Assets.resources.power.path,
    TEMPERATURE: Assets.globalParameters.temperature.path,
    RESTRICTED: Assets.resources.radiation.path,
    ASTEROID: Assets.resources.asteroid.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
