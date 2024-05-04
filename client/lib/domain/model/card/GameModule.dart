import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

enum GameModule {
  BASE,
  CORPERA,
  PROMO,
  VENUS,
  COLONIES,
  PRELUDE,
  PRELUDE2,
  TURMOIL,
  COMMUNITY,
  ARES,
  MOON,
  PATHFINDER,
  CEO,
  STARWARS,
  UNDERWORLD;

  static const _TO_STRING_MAP = {
    BASE: 'base',
    CORPERA: 'corpera',
    PROMO: 'promo',
    VENUS: 'venus',
    COLONIES: 'colonies',
    PRELUDE: 'prelude',
    PRELUDE2: 'prelude2',
    TURMOIL: 'turmoil',
    COMMUNITY: 'community',
    ARES: 'ares',
    MOON: 'moon',
    PATHFINDER: 'pathfinders',
    CEO: 'ceo',
    STARWARS: 'starwars',
    UNDERWORLD: 'underworld'
  };

  static final _MODULE_NAMES = {
    BASE: 'Base',
    CORPERA: 'Corporate Era',
    PROMO: 'Promo',
    VENUS: 'Venus Next',
    COLONIES: 'Colonies',
    PRELUDE: 'Prelude',
    PRELUDE2: 'Prelude 2',
    TURMOIL: 'Turmoil',
    COMMUNITY: 'Community',
    ARES: 'Ares',
    MOON: 'The Moon',
    PATHFINDER: 'Pathfinders',
    CEO: 'CEOs',
    STARWARS: 'Star Wars',
    UNDERWORLD: 'Underworld',
  };

  String? get moduleName => _MODULE_NAMES[this];

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
    STARWARS: Assets.cardModuleIcons.starWars.path,
    CEO: Assets.cardModuleIcons.ceo.path,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  String? toIconPath() => _TO_ICON_PATH_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value];

  static GameModule fromJson(String value) {
    try {
      return _TO_ENUM_MAP[value]!;
    } catch (e) {
      throw ('GameModule.fromJson: $value', e);
    }
  }

  String toJson() => toString();
}
