import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';

enum RequirementType {
  OXYGEN,
  TEMPERATURE,
  OCEANS,
  VENUS,
  TR,
  RESOURCE_TYPES,
  GREENERIES,
  CITIES,
  COLONIES,
  FLOATERS,
  CHAIRMAN,
  PARTY_LEADERS,
  TAG,
  PRODUCTION,
  PARTY,
  REMOVED_PLANTS,
  HABITAT_RATE,
  MINING_RATE,
  LOGISTIC_RATE,
  HABITAT_TILES,
  MINING_TILES,
  ROAD_TILES,
  EXCAVATION,
  CORRUPTION,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    OXYGEN: 'O2',
    TEMPERATURE: 'C',
    OCEANS: 'Ocean',
    VENUS: 'Venus',
    TR: 'TR',
    RESOURCE_TYPES: 'Resource type',
    GREENERIES: 'Greenery',
    CITIES: 'City',
    COLONIES: 'Colony',
    FLOATERS: 'Floater',
    CHAIRMAN: 'Chairman',
    PARTY_LEADERS: 'Party leader',
    TAG: 'tag',
    PRODUCTION: 'production',
    PARTY: 'party',
    REMOVED_PLANTS: 'Removed plants',
    HABITAT_RATE: 'Habitat rate',
    MINING_RATE: 'Mining rate',
    LOGISTIC_RATE: 'Logistic rate',
    HABITAT_TILES: 'Habitat tiles',
    MINING_TILES: 'Mine tiles',
    ROAD_TILES: 'Road tiles',
    // Underworld
    EXCAVATION: 'Excavation',
    CORRUPTION: 'Corruption',
  };
  static final _TO_IMAGE_PATH_MAP = {
    OXYGEN: Assets.globalParameters.oxygen.path,
    TEMPERATURE: Assets.globalParameters.temperature.path,
    OCEANS: Assets.tiles.ocean.path,
    VENUS: Assets.globalParameters.venus.path,
    TR: Assets.resources.tr.path,
    RESOURCE_TYPES: Assets.resources.wild.path,
    GREENERIES: Assets.tiles.greeneryNoO2.path,
    CITIES: Assets.tiles.city.path,
    COLONIES: Assets.tiles.colony.path,
    FLOATERS: Assets.resources.floater.path,
    CHAIRMAN: Assets.misc.chairman.path,
    PARTY_LEADERS: Assets.misc.delegate.path,
    REMOVED_PLANTS: Assets.resources.plant.path,
    HABITAT_RATE: Assets.moon.cardColonyRate.path,
    MINING_RATE: Assets.moon.cardMiningRate.path,
    LOGISTIC_RATE: Assets.moon.cardLogisticsRate.path,
    HABITAT_TILES: Assets.moon.colonytile.path,
    MINING_TILES: Assets.moon.minetile.path,
    ROAD_TILES: Assets.moon.roadtile.path,
  };
  static final _TO_ITEM_SHAPE_MAP = {
    OCEANS: ItemShape.hexagon,
    FLOATERS: ItemShape.square,
    RESOURCE_TYPES: ItemShape.square,
    CITIES: ItemShape.hexagon,
    GREENERIES: ItemShape.hexagon,
    COLONIES: ItemShape.triangle,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  ItemShape? toItemShape() => _TO_ITEM_SHAPE_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
