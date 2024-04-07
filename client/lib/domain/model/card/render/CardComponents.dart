import '../../TileType.dart';
import '../Tag.dart';
import 'AltSecondaryTag.dart';
import 'CardRenderItemType.dart';
import 'CardRenderSymbolType.dart';
import 'Size.dart';

enum CardRenderComponentType {
  ROOT,
  TEXT,
  SYMBOL,
  TILE,
  PRODUCTION_BOX,
  EFFECT,
  CORP_BOX_EFFECT,
  CORP_BOX_ACTION,
  ITEM,
  UNKNOWN;

  static const _TO_STRING_MAP = {
    ROOT: 'root',
    TEXT: 'text',
    SYMBOL: 'symbol',
    TILE: 'tile',
    PRODUCTION_BOX: 'production-box',
    EFFECT: 'effect',
    CORP_BOX_EFFECT: 'corp-box-effect',
    CORP_BOX_ACTION: 'corp-box-action',
    ITEM: 'item',
    UNKNOWN: 'Unknown',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? 'Unknown';
  static fromString(String value) => _TO_ENUM_MAP[value] ?? UNKNOWN;
}

class CardComponent {
  CardComponent();
  factory CardComponent.fromJson(json) {
    if (json == null) return ICardRenderText(text: '');
    if (json.runtimeType == String)
      return ICardRenderText(text: '(' + json + ')');
    switch (CardRenderComponentType.fromString(json['is'])) {
      case CardRenderComponentType.ROOT:
        return ICardRenderRoot.fromJson(json);
      case CardRenderComponentType.TEXT:
        return ICardRenderText.fromJson(json);
      case CardRenderComponentType.SYMBOL:
        return ICardRenderSymbol.fromJson(json);
      case CardRenderComponentType.TILE:
        return ICardRenderTile.fromJson(json);
      case CardRenderComponentType.PRODUCTION_BOX:
        return ICardRenderProductionBox.fromJson(json);
      case CardRenderComponentType.EFFECT:
        return ICardRenderEffect.fromJson(json);
      case CardRenderComponentType.CORP_BOX_EFFECT:
        return ICardRenderCorpBoxEffect.fromJson(json);
      case CardRenderComponentType.CORP_BOX_ACTION:
        return ICardRenderCorpBoxAction.fromJson(json);
      case CardRenderComponentType.ITEM:
        return ICardRenderItem.fromJson(json);
      case CardRenderComponentType.UNKNOWN:
        return ICardRenderText.fromJson(json);
      default:
        throw Exception('Unknown CardComponent type: ${json['is']}');
    }
  }
}

class ICardRenderText extends CardComponent {
  String text;
  ICardRenderText({required this.text});
  factory ICardRenderText.fromJson(json) {
    return ICardRenderText(
        text: json['text'] != null
            ? json['text']
            : json == String
                ? '(' + json + ')'
                : '');
  }
}

class ICardRenderRoot extends CardComponent {
  List<List<CardComponent>> rows;
  ICardRenderRoot({required this.rows});
  factory ICardRenderRoot.fromJson(json) {
    return ICardRenderRoot(
      rows: json['rows'] == null
          ? <List<CardComponent>>[]
          : json['rows']
              .map((e) => e
                  .map((e) => CardComponent.fromJson(e))
                  .cast<CardComponent>()
                  .toList())
              .cast<List<CardComponent>>()
              .toList(),
    );
  }
}

class ICardRenderSymbol extends CardComponent {
  CardRenderSymbolType type;
  CardItemSize size;
  bool isIcon;
  ICardRenderSymbol(
      {required this.type, required this.size, required this.isIcon});
  factory ICardRenderSymbol.fromJson(json) {
    return ICardRenderSymbol(
      type: CardRenderSymbolType.fromString(json['type']),
      size: CardItemSize.fromString(json['size']),
      isIcon: json['isIcon'] ?? false,
    );
  }
}

class ICardRenderTile extends CardComponent {
  TileType tile;
  bool hasSymbol;
  bool isAres;
  ICardRenderTile(
      {required this.tile, required this.hasSymbol, required this.isAres});
  factory ICardRenderTile.fromJson(json) {
    return ICardRenderTile(
      tile: json['tile'].runtimeType == int
          ? TileType.values[json['tile']]
          : TileType.fromString(json['tile']),
      hasSymbol: json['hasSymbol'] ?? false,
      isAres: json['isAres'] ?? false,
    );
  }
}

class ICardRenderProductionBox extends CardComponent {
  List<List<CardComponent>> rows;
  ICardRenderProductionBox({required this.rows});
  factory ICardRenderProductionBox.fromJson(json) {
    return ICardRenderProductionBox(
      rows: json['rows'] == null
          ? <List<CardComponent>>[]
          : json['rows']
              .map((e) => e
                  .map((e) => CardComponent.fromJson(e))
                  .cast<CardComponent>()
                  .toList())
              .cast<List<CardComponent>>()
              .toList(),
    );
  }
}

class ICardRenderEffect extends CardComponent {
  List<List<CardComponent>> rows;
  ICardRenderEffect({required this.rows});
  factory ICardRenderEffect.fromJson(json) {
    return ICardRenderEffect(
      rows: json['rows'] == null
          ? <List<CardComponent>>[]
          : json['rows']
              .map((e) => e
                  .map((e) => CardComponent.fromJson(e))
                  .cast<CardComponent>()
                  .toList())
              .cast<List<CardComponent>>()
              .toList(),
    );
  }
}

class ICardRenderCorpBoxEffect extends CardComponent {
  List<List<CardComponent>> rows;
  ICardRenderCorpBoxEffect({required this.rows});
  factory ICardRenderCorpBoxEffect.fromJson(json) {
    return ICardRenderCorpBoxEffect(
      rows: json['rows'] == null
          ? <List<CardComponent>>[]
          : json['rows']
              .map((e) => e
                  .map((e) => CardComponent.fromJson(e))
                  .cast<CardComponent>()
                  .toList())
              .cast<List<CardComponent>>()
              .toList(),
    );
  }
}

class ICardRenderCorpBoxAction extends CardComponent {
  List<List<CardComponent>> rows;
  ICardRenderCorpBoxAction({required this.rows});
  factory ICardRenderCorpBoxAction.fromJson(json) {
    return ICardRenderCorpBoxAction(
      rows: json['rows'] == null
          ? <List<CardComponent>>[]
          : json['rows']
              .map((e) => e
                  .map((e) => CardComponent.fromJson(e))
                  .cast<CardComponent>()
                  .toList())
              .cast<List<CardComponent>>()
              .toList(),
    );
  }
}

class SecondaryTag {
  Tag? tag;
  AltSecondaryTag? secTag;
  SecondaryTag({this.tag, this.secTag});
  factory SecondaryTag.fromJson(json) {
    final Tag? tag = json == null ? null : Tag.fromString(json);
    final AltSecondaryTag secTag =
        json == null ? null : AltSecondaryTag.fromString(json);
    return SecondaryTag(
      tag: tag,
      secTag: secTag == AltSecondaryTag.UNKNOWN ? null : secTag,
    );
  }
}

class ICardRenderItem extends CardComponent {
  /** The thing being drawn */
  CardRenderItemType type;
  /** The number of times it is drawn (or MC count) */
  int amount;
  /** activated for any player */
  bool? anyPlayer;
  /** render a digit instead of chain of items */
  bool? showDigit;
  /** show the amount for the item in its container */
  bool? amountInside;
  /** used to mark an item as 'played' e.g. event tags */
  bool? isPlayed;
  /** used text instead of integers in some cases */
  String? text;
  /** for uppercase text */
  bool? isUppercase;
  /** for bold text */
  bool? isBold;
  /** used to mark plate a.k.a. text with golden background */
  bool? isPlate;
  /** Size of the item. Very much depends on the CSS rendered for this item. */
  CardItemSize size;
  /** adding tag dependency (top right bubble of this item) */
  SecondaryTag? secondaryTag;
  /** used for amount labels like 2x, x, etc. */
  bool? multiplier;
  /** places the pathfinder Clone symbol in the object */
  bool? clone;
  /** add a symbol on top of the item to show it's cancelled or negated in some way (usually X) */
  bool? cancelled;
  /** over is used for rendering under TR for global events. */
  int? over;
  // Used for unknown values (currently just megacredits, fwiw)
  bool? questionMark;
  ICardRenderItem({
    required this.type,
    required this.amount,
    this.anyPlayer,
    this.showDigit,
    this.amountInside,
    this.isPlayed,
    this.text,
    this.isUppercase,
    this.isBold,
    this.isPlate,
    required this.size,
    this.secondaryTag,
    this.multiplier,
    this.clone,
    this.cancelled,
    this.over,
    this.questionMark,
  });
  factory ICardRenderItem.fromJson(json) {
    var res = ICardRenderItem(
      type: CardRenderItemType.fromString(json['type']),
      amount: json['amount'],
      anyPlayer: json['anyPlayer'] ?? false,
      showDigit: json['showDigit'] ?? false,
      amountInside: json['amountInside'] ?? false,
      isPlayed: json['isPlayed'] ?? false,
      text: json['text'] ?? null,
      isUppercase: json['isUppercase'] ?? false,
      isBold: json['isBold'] ?? false,
      isPlate: json['isPlate'] ?? false,
      size: json['size'] == null
          ? CardItemSize.MEDIUM
          : CardItemSize.fromString(json['size']),
      secondaryTag: json['secondaryTag'] == null
          ? null
          : SecondaryTag.fromJson(json['secondaryTag']),
      multiplier: json['multiplier'] ?? false,
      clone: json['clone'] ?? false,
      cancelled: json['cancelled'] ?? false,
      over: json['over'] ?? null,
      questionMark: json['questionMark'] ?? false,
    );
    return res;
  }
}
