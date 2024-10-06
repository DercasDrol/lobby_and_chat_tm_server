import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderSymbolType.dart';
import 'package:mars_flutter/domain/model/card/render/Size.dart';

enum AgendaStyle {
  STANDARD,
  RANDOM,
  CHAIRMAN;

  static const _TO_STRING_MAP = {
    STANDARD: 'Standard',
    RANDOM: 'Random',
    CHAIRMAN: 'Chairman',
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();

  static AgendaStyle? fromString(String? value) => _TO_ENUM_MAP[value];
}

class BonusId {
  final String? id;

  BonusId._(this.id);
  factory BonusId.fromString(string) {
    return BonusId._(RegExp(r'[m,s,u,k,r,g][b][0][1,2]').hasMatch(string) &&
            string.length == 4
        ? string
        : null);
  }
  CardComponent get renderData => ICardRenderRoot(rows: [
        id == 'mb01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.BUILDING,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'mb02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.EMPTY_TILE,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'sb01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.SCIENCE,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'sb02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.CARDS,
                  amount: 3,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'ub01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.VENUS,
                  isPlayed: true,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.EARTH,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.JOVIAN,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'ub02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.SPACE,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'kb01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderProductionBox(rows: [
                  [
                    ICardRenderItem(
                      type: CardRenderItemType.HEAT,
                      amount: 1,
                      size: CardItemSize.MEDIUM,
                    ),
                  ]
                ]),
              ]
            : [],
        id == 'kb02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.HEAT,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderProductionBox(rows: [
                  [
                    ICardRenderItem(
                      type: CardRenderItemType.HEAT,
                      amount: 1,
                      size: CardItemSize.MEDIUM,
                    ),
                  ]
                ]),
              ]
            : [],
        id == 'rb01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.INFERIOR_TR,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TR,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'rb02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.INFERIOR_TR,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TR,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  anyPlayer: true,
                ),
              ]
            : [],
        id == 'gb01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.PLANTS,
                  isPlayed: true,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MICROBES,
                  isPlayed: true,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.ANIMALS,
                  isPlayed: true,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'gb02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 2,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.GREENERY,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
      ]);
  @override
  String toString() => id ?? 'undefined BonusId';
}

class PolicyId {
  final String? id;
  PolicyId._(this.id);
  factory PolicyId.fromString(string) {
    return PolicyId._(RegExp(string.length == 4
                    ? r'[m,s,u,k,r,g][p][0][1,2]'
                    : r'[m,s,u,k,r,g][f][p][0][1,2]')
                .hasMatch(string) &&
            (string.length == 4 || string.length == 5)
        ? string
        : null);
  }
  CardComponent get renderData => ICardRenderRoot(rows: [
        id == 'mfp01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.EMPTY_TILE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.STEEL,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'mfp02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.BUILDING,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 2,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'mfp03'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.STEEL,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.PLUS,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'mfp04'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 4,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW_3X,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.CARDS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  secondaryTag: SecondaryTag(tag: Tag.BUILDING),
                ),
              ]
            : [],
        id == 'sp01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 10,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.CARDS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.CARDS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.CARDS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'sp02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.OXYGEN,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.OCEANS,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TEMPERATURE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TEXT,
                  text: " ± 2",
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'sp03'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.OXYGEN,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.OCEANS,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TEMPERATURE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.CARDS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'sp04'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.SCIENCE,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'up01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.TITANIUM,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.PLUS,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'up02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 4,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW_3X,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TITANIUM,
                  amount: 2,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.FLOATERS,
                  amount: 2,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'up03'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 4,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW_3X,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.CARDS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  secondaryTag: SecondaryTag(tag: Tag.SPACE),
                ),
              ]
            : [],
        id == 'up04'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.SPACE,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: -2,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'kp01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 10,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW_INFINITY,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderProductionBox(rows: [
                  [
                    ICardRenderItem(
                      type: CardRenderItemType.ENERGY,
                      amount: 1,
                      size: CardItemSize.MEDIUM,
                    ),
                    ICardRenderItem(
                      type: CardRenderItemType.HEAT,
                      amount: 1,
                      size: CardItemSize.MEDIUM,
                    ),
                  ]
                ]),
              ]
            : [],
        id == 'kp02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.TEMPERATURE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 3,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'kp03'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.HEAT,
                  amount: 6,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW_INFINITY,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TEMPERATURE,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'kp04'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.EMPTY_TILE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.HEAT,
                  amount: 2,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'rp01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.TR,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: -3,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'rp02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.EMPTY_TILE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: -3,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'rp03'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 4,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW_3X,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.OXYGEN,
                  amount: 1,
                  size: CardItemSize.SMALL,
                  anyPlayer: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.OCEANS,
                  amount: 1,
                  size: CardItemSize.SMALL,
                  anyPlayer: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TEMPERATURE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                  anyPlayer: true,
                ),
              ]
            : [],
        id == 'rp04'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.OXYGEN,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.OCEANS,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.TEMPERATURE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderProductionBox(rows: [
                  [
                    ICardRenderItem(
                      type: CardRenderItemType.MEGACREDITS,
                      amount: -1,
                      size: CardItemSize.MEDIUM,
                      amountInside: true,
                    ),
                  ]
                ]),
              ]
            : [],
        id == 'gp01'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.GREENERY,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 4,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'gp02'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.EMPTY_TILE,
                  amount: 1,
                  size: CardItemSize.SMALL,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.PLANTS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
        id == 'gp03'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.PLANTS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  isPlayed: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MICROBES,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  isPlayed: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.ANIMALS,
                  amount: 1,
                  size: CardItemSize.MEDIUM,
                  isPlayed: true,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.COLON,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 2,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
              ]
            : [],
        id == 'gp04'
            ? [
                ICardRenderItem(
                  type: CardRenderItemType.MEGACREDITS,
                  amount: 5,
                  size: CardItemSize.MEDIUM,
                  amountInside: true,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.RED_ARROW_3X,
                  size: CardItemSize.MEDIUM,
                  amount: 1,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.PLANTS,
                  amount: 3,
                  size: CardItemSize.MEDIUM,
                ),
                ICardRenderSymbol(
                  type: CardRenderSymbolType.SLASH,
                  size: CardItemSize.MEDIUM,
                  isIcon: false,
                ),
                ICardRenderItem(
                  type: CardRenderItemType.MICROBES,
                  amount: 2,
                  size: CardItemSize.MEDIUM,
                ),
              ]
            : [],
      ]);
  @override
  String toString() => id ?? 'undefined PolicyId';
}

class Agenda {
  final BonusId bonusId;
  final PolicyId policyId;
  Agenda({required this.bonusId, required this.policyId});

  static Agenda fromJson(Map<String, dynamic> json) {
    return Agenda(
      bonusId: BonusId.fromString(json['bonusId'] as String),
      policyId: PolicyId.fromString(json['policyId'] as String),
    );
  }
}
