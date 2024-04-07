enum CardRenderSymbolType {
  ASTERIX,
  OR,
  MINUS,
  PLUS,
  COLON,
  EMPTY,
  SLASH,
  ARROW,
  BRACKET_OPEN,
  BRACKET_CLOSE,
  NBSP,
  VSPACE,
  EQUALS,
  SURVEY_MISSION,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    ASTERIX: '*',
    OR: 'OR',
    MINUS: '-',
    PLUS: '+',
    COLON: ':',
    EMPTY: ' ',
    SLASH: '/',
    ARROW: '->',
    BRACKET_OPEN: '(',
    BRACKET_CLOSE: ')',
    NBSP: 'nbsp',
    VSPACE: 'vspace',
    EQUALS: '=',
    SURVEY_MISSION: 'survey-mission',
    UNKNOWN: "Unknown",
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  String toStringForUI() => _TO_STRING_MAP[this] == null
      ? 'Unknown'
      : _TO_STRING_MAP[this]!.replaceFirst('nbsp', '\u{00A0}');
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}
