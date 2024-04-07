import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum GameModule {
  BASE,
  CORPERA,
  PROMO,
  VENUS,
  COLONIES,
  PRELUDE,
  TURMOIL,
  COMMUNITY,
  ARES,
  MOON,
  PATHFINDER,
  CEO,
  UNDERWORLD,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    BASE: 'base',
    CORPERA: 'corpera',
    PROMO: 'promo',
    VENUS: 'venus',
    COLONIES: 'colonies',
    PRELUDE: 'prelude',
    TURMOIL: 'turmoil',
    COMMUNITY: 'community',
    ARES: 'ares',
    MOON: 'moon',
    PATHFINDER: 'pathfinders',
    CEO: 'ceo',
    UNDERWORLD: 'underworld',
    UNKNOWN: 'Unknown',
  };
  static final _TO_ICON_PATH_MAP = {
    CORPERA: Assets.cardModuleIcons.corpera.path,
    PROMO: Assets.cardModuleIcons.promo.path,
    VENUS: Assets.cardModuleIcons.venus.path,
    COLONIES: Assets.cardModuleIcons.colonies.path,
    PRELUDE: Assets.cardModuleIcons.prelude.path,
    TURMOIL: Assets.cardModuleIcons.turmoil.path,
    COMMUNITY: Assets.cardModuleIcons.community.path,
    ARES: Assets.cardModuleIcons.ares.path,
    MOON: Assets.cardModuleIcons.moon.path,
    PATHFINDER: Assets.cardModuleIcons.pathfinders.path,
    UNDERWORLD: Assets.cardModuleIcons.underworld.path,
    CEO: Assets.cardModuleIcons.ceo.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  String? toIconPath() => _TO_ICON_PATH_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
