enum DescriptionAlign {
  LEFT,
  CENTER,
  RIGHT,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    LEFT: 'left',
    CENTER: 'center',
    RIGHT: 'right',
    UNKNOWN: 'Unknown',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? CENTER;
}

class ICardRenderDescription {
  String text;
  DescriptionAlign align;

  ICardRenderDescription(this.text, this.align);

  factory ICardRenderDescription.fromJson(Map<String, dynamic> json) {
    return ICardRenderDescription(
      json['text'],
      DescriptionAlign.fromString(json['align']),
    );
  }
}
