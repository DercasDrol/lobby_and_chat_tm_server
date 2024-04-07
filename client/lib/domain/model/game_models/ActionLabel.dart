enum ActionLabel {
  ACTIVE,
  PASSED,
  NEXT,
  NONE,
  DRAFTING,
  RESEARCHING;

  static const _TO_STRING_MAP = {
    ACTIVE: 'active',
    PASSED: 'passed',
    NEXT: 'next',
    NONE: 'none',
    DRAFTING: 'drafting',
    RESEARCHING: 'researching',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String value) => _TO_ENUM_MAP[value] ?? NONE;
}
