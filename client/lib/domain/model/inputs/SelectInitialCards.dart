/**export const SELECT_CORPORATION_TITLE = 'Select corporation' as const;
export const SELECT_PRELUDE_TITLE = 'Select 2 Prelude cards' as const;
export const SELECT_CEO_TITLE = 'Select CEO' as const;
export const SELECT_PROJECTS_TITLE = 'Select initial cards to buy' as const;
 */
enum SelectInitialCards {
  SELECT_CORPORATION_TITLE,
  SELECT_PRELUDE_TITLE,
  SELECT_CEO_TITLE,
  SELECT_PROJECTS_TITLE;

  static const _TO_STRING_MAP = {
    SELECT_CORPORATION_TITLE: 'Select corporation',
    SELECT_PRELUDE_TITLE: 'Select 2 Prelude cards',
    SELECT_CEO_TITLE: 'Select CEO',
    SELECT_PROJECTS_TITLE: 'Select initial cards to buy',
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
