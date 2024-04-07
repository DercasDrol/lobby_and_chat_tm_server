enum AltSecondaryTag {
  REQ,
  OXYGEN,
  TURMOIL,
  FLOATER,
  BLUE,
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

    MOON_MINING_RATE: 'moon-mine',
    MOON_HABITAT_RATE: 'moon-colony',
    MOON_LOGISTICS_RATE: 'moon-road',

    NO_PLANETARY_TAG: 'no_planetary_tag',
    WILD_RESOURCE: 'wild-resource',

    // used in Faraday CEO
    DIVERSE: 'diverse',
    UNKNOWN: 'unknown',
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
