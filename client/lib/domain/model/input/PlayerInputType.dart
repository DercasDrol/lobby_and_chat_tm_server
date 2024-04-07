import 'package:mars_flutter/domain/model/inputs/InputResponse.dart';

enum PlayerInputType {
  AND,
  OR,
  AMOUNT,
  CARD,
  DELEGATE,
  PAYMENT,
  PROJECT_CARD,
  INITIAL_CARDS,
  OPTION,
  PARTY,
  PLAYER,
  SPACE,
  COLONY,
  PRODUCTION_TO_LOSE,
  ARES_GLOBAL_PARAMETERS;

  static const _TO_STRING_MAP = {
    AND: 'and',
    OR: 'or',
    AMOUNT: 'amount',
    CARD: 'card',
    DELEGATE: 'delegate',
    PAYMENT: 'payment',
    PROJECT_CARD: 'projectCard',
    INITIAL_CARDS: 'initialCards',
    OPTION: 'option',
    PARTY: 'party',
    PLAYER: 'player',
    SPACE: 'space',
    COLONY: 'colony',
    PRODUCTION_TO_LOSE: 'productionToLose',
    ARES_GLOBAL_PARAMETERS: 'aresGlobalParameters',
  };

  static const _TO_INPUT_RESPONCE_TYPE_MAP = {
    AND: ResponseType.AND,
    OR: ResponseType.OR,
    AMOUNT: ResponseType.AMOUNT,
    CARD: ResponseType.CARD,
    DELEGATE: ResponseType.DELEGATE,
    PAYMENT: ResponseType.PAYMENT,
    PROJECT_CARD: ResponseType.PROJECT_CARD,
    OPTION: ResponseType.OPTION,
    PARTY: ResponseType.PARTY,
    PLAYER: ResponseType.PLAYER,
    SPACE: ResponseType.SPACE,
    COLONY: ResponseType.COLONY,
    PRODUCTION_TO_LOSE: ResponseType.PRODUCTION_TO_LOSE,
    ARES_GLOBAL_PARAMETERS: ResponseType.ARES_GLOBAL_PARAMETERS,
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  ResponseType? toResponseType() => _TO_INPUT_RESPONCE_TYPE_MAP[this];
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();

  static fromString(String? value) => _TO_ENUM_MAP[value];
}
