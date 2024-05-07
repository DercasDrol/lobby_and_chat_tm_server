import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum AltSecondaryTag {
  REQ,
  OXYGEN,
  TURMOIL,
  FLOATER,
  BLUE,
  NO_TAGS,
  MOON_MINING_RATE,
  MOON_HABITAT_RATE,
  MOON_LOGISTICS_RATE,
  NO_PLANETARY_TAG,
  WILD_RESOURCE,
  DIVERSE,
  UNKNOWN;

  /** Tags that belong in `CardRenderItem.secondaryTag` that aren't part of `Tags`. */
  static const _TO_STRING_MAP = {
    // 'req':> used for Cutting Edge Technology's discount on cards with requirements
    REQ: 'req',
    // 'oxygen':> used for Greenery tile that increases oxygen on placement
    OXYGEN: 'oxygen',
    // 'turmoil':> used in Political Uprising community prelude
    TURMOIL: 'turmoil',
    FLOATER: 'floater',
    BLUE: 'blue',

    NO_TAGS: 'no_tags',
    MOON_MINING_RATE: 'moon-mine',
    MOON_HABITAT_RATE: 'moon-colony',
    MOON_LOGISTICS_RATE: 'moon-road',

    NO_PLANETARY_TAG: 'no_planetary_tag',
    WILD_RESOURCE: 'wild-resource',

    // used in Faraday CEO
    DIVERSE: 'diverse',
    UNKNOWN: 'unknown',
  };

  static final _TO_IMAGE_PATH_MAP = {
    //REQ: "requirements mini background",
    OXYGEN: Assets.globalParameters.oxygen.path,
    TURMOIL: Assets.cardModuleIcons.turmoil.path,
    FLOATER: Assets.resources.floater.path,
    //BLUE: "blue circle",
    //NO_TAGS: "ring",
    MOON_MINING_RATE: Assets.moon.cardMiningRate.path,
    MOON_HABITAT_RATE: Assets.moon.cardColonyRate.path,
    MOON_LOGISTICS_RATE: Assets.moon.cardLogisticsRate.path,
    //NO_PLANETARY_TAG: "clone tag image with red cross",
    WILD_RESOURCE: Assets.resources.wild.path,
    //DIVERSE: "circle with 3 different colors",
  };

  String? toImagePath() => _TO_IMAGE_PATH_MAP[this];
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
