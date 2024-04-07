/**enum Phase {
    ACTION = 'action',
    END = 'end', // specifically, *game* end.
    PRODUCTION = 'production',
    RESEARCH = 'research',
    INITIALDRAFTING = 'initial_drafting',
    DRAFTING = 'drafting',
    PRELUDES = 'preludes',
    CEOS = 'ceos',
    SOLAR = 'solar',
    INTERGENERATION = 'intergeneration',
}
 */
enum Phase {
  ACTION,
  END, // specifically, *game* end.
  PRODUCTION,
  RESEARCH,
  INITIALDRAFTING,
  DRAFTING,
  PRELUDES,
  CEOS,
  SOLAR,
  INTERGENERATION;

  static const _TO_STRING_MAP = {
    ACTION: 'action',
    END: 'end',
    PRODUCTION: 'production',
    RESEARCH: 'research',
    INITIALDRAFTING: 'initial_drafting',
    DRAFTING: 'drafting',
    PRELUDES: 'preludes',
    CEOS: 'ceos',
    SOLAR: 'solar',
    INTERGENERATION: 'intergeneration',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
