enum CardItemSize {
  SMALL,
  MEDIUM,
  LARGE,
  TINY,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    SMALL: 'S',
    MEDIUM: 'M',
    LARGE: 'L',
    TINY: 'XS',
    UNKNOWN: 'Unknown',
  };
  static const _TO_MULTIPLIER_MAP = {
    SMALL: 0.75,
    MEDIUM: 1.0,
    LARGE: 1.4,
    TINY: 0.55,
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  double toMultiplier() => _TO_MULTIPLIER_MAP[this] ?? 1.0;
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
