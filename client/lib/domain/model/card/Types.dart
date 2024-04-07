import 'Tag.dart';

enum CardDiscountPer {
  CARD,
  TAG,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    CARD: 'card',
    TAG: 'tag',
    UNKNOWN: 'Unknown',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}

class CardDiscount {
  Tag? tag; // When absent, discount applies to all tags.
  int amount;
  CardDiscountPer? per;
  CardDiscount({this.tag, required this.amount, this.per});
  factory CardDiscount.fromJson(json) {
    return CardDiscount(
      tag: json['tag'] == null ? null : Tag.fromString(json['tag']),
      amount: json['amount'],
      per: json['per'] == null ? null : CardDiscountPer.fromString(json['per']),
    );
  }
}
