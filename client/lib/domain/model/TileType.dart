//import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

import 'package:mars_flutter/domain/model/card/CardName.dart';

enum TileType {
  GREENERY, // 0
  OCEAN, // 1
  CITY, // 2
  CAPITAL, // 3
  COMMERCIAL_DISTRICT, // 4
  ECOLOGICAL_ZONE, // 5
  INDUSTRIAL_CENTER, // 6
  LAVA_FLOWS, // 7
  MINING_AREA, // 8
  MINING_RIGHTS, // 9
  MOHOLE_AREA, // 10
  NATURAL_PRESERVE, // 11
  NUCLEAR_ZONE, // 12
  RESTRICTED_AREA, // 13

  DEIMOS_DOWN, // 14
  GREAT_DAM, // 15
  MAGNETIC_FIELD_GENERATORS, // 16

  BIOFERTILIZER_FACILITY, // 17
  METALLIC_ASTEROID, // 18
  SOLAR_FARM, // 19
  OCEAN_CITY, // 20
  OCEAN_FARM, // 21
  OCEAN_SANCTUARY, // 22
  DUST_STORM_MILD, // 23
  DUST_STORM_SEVERE, // 24
  EROSION_MILD, // 25
  EROSION_SEVERE, // 26
  MINING_STEEL_BONUS, // 27
  MINING_TITANIUM_BONUS, // 28
  // The Moon
  MOON_MINE, // 29
  MOON_HABITAT, //  30
  MOON_ROAD, //  31
  LUNA_TRADE_STATION, //  32
  LUNA_MINING_HUB, //  33
  LUNA_TRAIN_STATION, //  34
  LUNAR_MINE_URBANIZATION, //  35
  // Pathfinders
  WETLANDS, // 36
  RED_CITY, // 37
  MARTIAN_NATURE_WONDERS, // 38
  CRASHLANDING, // 39

  MARS_NOMADS, // 40
  REY_SKYWALKER, // 41

  // Underworld
  MAN_MADE_VOLCANO; // 42

  static final _TO_STRING_MAP = {
    GREENERY: 'greenery',
    OCEAN: 'ocean',
    CITY: 'city',
    CAPITAL: CardName.CAPITAL.toString(),
    COMMERCIAL_DISTRICT: CardName.COMMERCIAL_DISTRICT.toString(),
    ECOLOGICAL_ZONE: CardName.ECOLOGICAL_ZONE.toString(),
    INDUSTRIAL_CENTER: CardName.INDUSTRIAL_CENTER.toString(),
    LAVA_FLOWS: CardName.LAVA_FLOWS.toString(),
    MINING_AREA: CardName.MINING_AREA.toString(),
    MINING_RIGHTS: CardName.MINING_RIGHTS.toString(),
    MOHOLE_AREA: CardName.MOHOLE_AREA.toString(),
    NATURAL_PRESERVE: CardName.NATURAL_PRESERVE.toString(),
    NUCLEAR_ZONE: CardName.NUCLEAR_ZONE.toString(),
    RESTRICTED_AREA: CardName.RESTRICTED_AREA.toString(),
    DEIMOS_DOWN: CardName.DEIMOS_DOWN.toString(),
    GREAT_DAM: CardName.GREAT_DAM.toString(),
    MAGNETIC_FIELD_GENERATORS: CardName.MAGNETIC_FIELD_GENERATORS.toString(),
    BIOFERTILIZER_FACILITY: CardName.BIOFERTILIZER_FACILITY.toString(),
    METALLIC_ASTEROID: CardName.METALLIC_ASTEROID.toString(),
    SOLAR_FARM: CardName.SOLAR_FARM.toString(),
    OCEAN_CITY: CardName.OCEAN_CITY.toString(),
    OCEAN_FARM: CardName.OCEAN_FARM.toString(),
    OCEAN_SANCTUARY: CardName.OCEAN_SANCTUARY.toString(),
    DUST_STORM_MILD: 'Mild Dust Storm',
    DUST_STORM_SEVERE: 'Severe Dust Storm',
    EROSION_MILD: 'Mild Erosion',
    EROSION_SEVERE: 'Severe Erosion',
    MINING_STEEL_BONUS: 'Mining (Steel)',
    MINING_TITANIUM_BONUS: 'Mining (Titanium)',
    MOON_MINE: 'Mine',
    MOON_HABITAT: 'Habitat',
    MOON_ROAD: 'Road',
    LUNA_TRADE_STATION: CardName.LUNA_TRADE_STATION.toString(),
    LUNA_MINING_HUB: CardName.LUNA_MINING_HUB.toString(),
    LUNA_TRAIN_STATION: CardName.LUNA_TRAIN_STATION.toString(),
    LUNAR_MINE_URBANIZATION: CardName.LUNAR_MINE_URBANIZATION.toString(),
    WETLANDS: CardName.WETLANDS.toString(),
    RED_CITY: CardName.RED_CITY.toString(),
    MARTIAN_NATURE_WONDERS: CardName.MARTIAN_NATURE_WONDERS.toString(),
    CRASHLANDING: CardName.CRASHLANDING.toString(),
    MARS_NOMADS: CardName.MARS_NOMADS.toString(),
    REY_SKYWALKER: CardName.REY_SKYWALKER.toString(),
    MAN_MADE_VOLCANO: CardName.MAN_MADE_VOLCANO.toString(),
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String value) => _TO_ENUM_MAP[value];
  //String? toImagePath() => _TO_IMAGE_PATH_MAP[this];

  static const Set<TileType> BASE_OCEAN_TILES = {OCEAN, WETLANDS};
  static const Set<TileType> GREENERY_TILES = {GREENERY, WETLANDS};
// Ares Tiles handling
  static const Set<TileType> HAZARD_TILES = {
    DUST_STORM_MILD,
    DUST_STORM_SEVERE,
    EROSION_MILD,
    EROSION_SEVERE
  };
  static const Set<TileType> OCEAN_UPGRADE_TILES = {
    OCEAN_CITY,
    OCEAN_FARM,
    OCEAN_SANCTUARY
  };
  static const Set<TileType> CITY_TILES = {CITY, CAPITAL, OCEAN_CITY, RED_CITY};
  static const Set<TileType> OCEAN_TILES = {
    OCEAN,
    OCEAN_CITY,
    OCEAN_FARM,
    OCEAN_SANCTUARY,
    WETLANDS
  };
  bool isHazardTileType() {
    return HAZARD_TILES.contains(this);
  }
}
