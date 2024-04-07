enum RandomMAOptionType {
  NONE,
  LIMITED,
  UNLIMITED;

  static const _TO_STRING_MAP = {
    NONE: 'No randomization',
    LIMITED: 'Limited synergy',
    UNLIMITED: 'Full random'
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
