//import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum TileType {
  GREENERY,
  OCEAN,
  CITY,
  CAPITAL,
  COMMERCIAL_DISTRICT,
  ECOLOGICAL_ZONE,
  INDUSTRIAL_CENTER,
  LAVA_FLOWS,
  MINING_AREA,
  MINING_RIGHTS,
  MOHOLE_AREA,
  NATURAL_PRESERVE,
  NUCLEAR_ZONE,
  RESTRICTED_AREA,
  DEIMOS_DOWN,
  GREAT_DAM,
  MAGNETIC_FIELD_GENERATORS,
  BIOFERTILIZER_FACILITY,
  METALLIC_ASTEROID,
  SOLAR_FARM,
  OCEAN_CITY,
  OCEAN_FARM,
  OCEAN_SANCTUARY,
  DUST_STORM_MILD,
  DUST_STORM_SEVERE,
  EROSION_MILD,
  EROSION_SEVERE,
  MINING_STEEL_BONUS,
  MINING_TITANIUM_BONUS,
  MOON_MINE,
  MOON_HABITAT,
  MOON_ROAD,
  LUNA_TRADE_STATION,
  LUNA_MINING_HUB,
  LUNA_TRAIN_STATION,
  LUNAR_MINE_URBANIZATION,
  WETLANDS,
  RED_CITY,
  MARTIAN_NATURE_WONDERS,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    GREENERY: 'greenery',
    OCEAN: 'ocean',
    CITY: 'city',
    CAPITAL: 'Capital',
    COMMERCIAL_DISTRICT: 'Commercial District',
    ECOLOGICAL_ZONE: 'Ecological Zone',
    INDUSTRIAL_CENTER: 'Industrial Center',
    LAVA_FLOWS: 'Lava Flows',
    MINING_AREA: 'Mining Area',
    MINING_RIGHTS: 'Mining Rights',
    MOHOLE_AREA: 'Mohole Area',
    NATURAL_PRESERVE: 'Natural Preserve',
    NUCLEAR_ZONE: 'Nuclear Zone',
    RESTRICTED_AREA: 'Restricted Area',
    DEIMOS_DOWN: 'Deimos Down',
    GREAT_DAM: 'Great Dam',
    MAGNETIC_FIELD_GENERATORS: 'Magnetic Field Generators',
    BIOFERTILIZER_FACILITY: 'Bio-Fertilizer Facility',
    METALLIC_ASTEROID: 'Metallic Asteroid',
    SOLAR_FARM: 'Solar Farm',
    OCEAN_CITY: 'Ocean City',
    OCEAN_FARM: 'Ocean Farm',
    OCEAN_SANCTUARY: 'Ocean Sanctuary',
    DUST_STORM_MILD: 'Mild Dust Storm',
    DUST_STORM_SEVERE: 'Severe Dust Storm',
    EROSION_MILD: 'Mild Erosion',
    EROSION_SEVERE: 'Severe Erosion',
    MINING_STEEL_BONUS: 'Mining (Steel)',
    MINING_TITANIUM_BONUS: 'Mining (Titanium)',
    MOON_MINE: 'Mine',
    MOON_HABITAT: 'Habitat',
    MOON_ROAD: 'Road',
    LUNA_TRADE_STATION: 'Luna Trade Station',
    LUNA_MINING_HUB: 'Luna Mining Hub',
    LUNA_TRAIN_STATION: 'Luna Train Station',
    LUNAR_MINE_URBANIZATION: 'Lunar Mine Urbanization',
    WETLANDS: 'Wetlands',
    RED_CITY: 'Red City',
    MARTIAN_NATURE_WONDERS: 'Martian Nature Wonders',
  };
  /*static final _TO_IMAGE_PATH_MAP = {
    GREENERY: Assets.tiles.greeneryNoO2.path,
    OCEAN: Assets.tiles.greeneryNoO2.path,
    CITY: Assets.tiles.greeneryNoO2.path,
    CAPITAL: Assets.tiles.greeneryNoO2.path,
    COMMERCIAL_DISTRICT: 'Commercial District',
    ECOLOGICAL_ZONE: 'Ecological Zone',
    INDUSTRIAL_CENTER: 'Industrial Center',
    LAVA_FLOWS: 'Lava Flows',
    MINING_AREA: 'Mining Area',
    MINING_RIGHTS: 'Mining Rights',
    MOHOLE_AREA: 'Mohole Area',
    NATURAL_PRESERVE: 'Natural Preserve',
    NUCLEAR_ZONE: 'Nuclear Zone',
    RESTRICTED_AREA: 'Restricted Area',
    DEIMOS_DOWN: 'Deimos Down',
    GREAT_DAM: 'Great Dam',
    MAGNETIC_FIELD_GENERATORS: 'Magnetic Field Generators',
    BIOFERTILIZER_FACILITY: 'Bio-Fertilizer Facility',
    METALLIC_ASTEROID: 'Metallic Asteroid',
    SOLAR_FARM: 'Solar Farm',
    OCEAN_CITY: 'Ocean City',
    OCEAN_FARM: 'Ocean Farm',
    OCEAN_SANCTUARY: 'Ocean Sanctuary',
    DUST_STORM_MILD: 'Mild Dust Storm',
    DUST_STORM_SEVERE: 'Severe Dust Storm',
    EROSION_MILD: 'Mild Erosion',
    EROSION_SEVERE: 'Severe Erosion',
    MINING_STEEL_BONUS: 'Mining (Steel)',
    MINING_TITANIUM_BONUS: 'Mining (Titanium)',
    MOON_MINE: 'Mine',
    MOON_HABITAT: 'Habitat',
    MOON_ROAD: 'Road',
    LUNA_TRADE_STATION: 'Luna Trade Station',
    LUNA_MINING_HUB: 'Luna Mining Hub',
    LUNA_TRAIN_STATION: 'Luna Train Station',
    LUNAR_MINE_URBANIZATION: 'Lunar Mine Urbanization',
    WETLANDS: 'Wetlands',
    RED_CITY: 'Red City',
    MARTIAN_NATURE_WONDERS: 'Martian Nature Wonders',
  };*/
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
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
