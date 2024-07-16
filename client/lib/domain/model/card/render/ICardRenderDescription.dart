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
  final String text;
  final DescriptionAlign align;
  final double sizeMultiplicator;

  ICardRenderDescription({
    required this.text,
    required this.align,
    this.sizeMultiplicator = 1.0,
  });

  factory ICardRenderDescription.fromJson(Map<String, dynamic> json) {
    return ICardRenderDescription(
      text: json['text'],
      align: DescriptionAlign.fromString(json['align']),
    );
  }
}
