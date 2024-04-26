enum SpaceType {
  LAND,
  OCEAN,
  COLONY,
  LUNAR_MINE,
  COVE,
  RESTRICTED;

  static const _TO_STRING_MAP = {
    LAND: 'land',
    OCEAN: 'ocean',
    COLONY: 'colony',
    LUNAR_MINE: 'lunar_mine', // Reserved for The Moon.
    COVE: 'cove', // Cove can represent an ocean and a land space.
    RESTRICTED: 'restricted', // Amazonis Planitia
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
