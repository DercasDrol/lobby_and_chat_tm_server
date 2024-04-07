import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/Units.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';
import 'package:mars_flutter/domain/model/inputs/AresGlobalParametersResponse.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';

enum ResponseType {
  OPTION,
  OR,
  AND,
  CARD,
  PROJECT_CARD,
  SPACE,
  PLAYER,
  PARTY,
  DELEGATE,
  AMOUNT,
  COLONY,
  PAYMENT,
  PRODUCTION_TO_LOSE,
  ARES_GLOBAL_PARAMETERS;

  static const _TO_STRING_MAP = {
    OPTION: 'option',
    OR: 'or',
    AND: 'and',
    CARD: 'card',
    PROJECT_CARD: 'projectCard',
    SPACE: 'space',
    PLAYER: 'player',
    PARTY: 'party',
    DELEGATE: 'delegate',
    AMOUNT: 'amount',
    COLONY: 'colony',
    PAYMENT: 'payment',
    PRODUCTION_TO_LOSE: 'productionToLose',
    ARES_GLOBAL_PARAMETERS: 'aresGlobalParameters',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}

final class SelectOptionResponse implements InputResponse {
  SelectOptionResponse();
  @override
  Map<String, dynamic> toJson() => {
        'type': ResponseType.OPTION.toString(),
      };
}

final class OrOptionsResponse implements InputResponse {
  final int index;
  final InputResponse response;
  OrOptionsResponse({required this.index, required this.response});
  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'response': response.toJson(),
        'type': ResponseType.OR.toString(),
      };
}

final class AndOptionsResponse implements InputResponse {
  final List<InputResponse> responses;
  AndOptionsResponse({required this.responses});
  @override
  Map<String, dynamic> toJson() => {
        'responses': responses.map((e) => e.toJson()).toList(),
        'type': ResponseType.AND.toString(),
      };
}

final class SelectCardResponse implements InputResponse {
  final List<CardName> cards;
  SelectCardResponse({required this.cards});
  @override
  Map<String, dynamic> toJson() => {
        'cards': cards.map((card) => card.toString()).toList(),
        'type': ResponseType.CARD.toString(),
      };
}

final class SelectProjectCardToPlayResponse implements InputResponse {
  final CardName card;
  final Payment payment;
  SelectProjectCardToPlayResponse({required this.card, required this.payment});
  @override
  Map<String, dynamic> toJson() => {
        'card': card.toString(),
        'payment': payment.toJson(),
        'type': ResponseType.PROJECT_CARD.toString(),
      };
}

final class SelectSpaceResponse implements InputResponse {
  final SpaceId spaceId;
  SelectSpaceResponse({required this.spaceId});
  @override
  Map<String, dynamic> toJson() => {
        'spaceId': spaceId.toString(),
        'type': ResponseType.SPACE.toString(),
      };
}

final class SelectPlayerResponse implements InputResponse {
  final PlayerColor player;
  SelectPlayerResponse({required this.player});
  @override
  Map<String, dynamic> toJson() => {
        'player': player.toString(),
        'type': ResponseType.PLAYER.toString(),
      };
}

final class SelectPartyResponse implements InputResponse {
  final PartyName partyName;
  SelectPartyResponse({required this.partyName});
  @override
  Map<String, dynamic> toJson() => {
        'partyName': partyName.toString(),
        'type': ResponseType.PARTY.toString(),
      };
}

final class SelectDelegateResponse implements InputResponse {
  final PlayerColor player;
  SelectDelegateResponse({required this.player});
  @override
  Map<String, dynamic> toJson() => {
        'player': player.toString(),
        'type': ResponseType.DELEGATE.toString(),
      };
}

final class SelectAmountResponse implements InputResponse {
  final int amount;
  SelectAmountResponse({required this.amount});
  @override
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'type': ResponseType.AMOUNT.toString(),
      };
}

final class SelectColonyResponse implements InputResponse {
  final ColonyName colonyName;
  SelectColonyResponse({required this.colonyName});
  @override
  Map<String, dynamic> toJson() => {
        'colonyName': colonyName.toString(),
        'type': ResponseType.COLONY.toString(),
      };
}

final class SelectPaymentResponse implements InputResponse {
  final Payment payment;
  SelectPaymentResponse({required this.payment});
  @override
  Map<String, dynamic> toJson() => {
        'payment': payment.toJson(),
        'type': ResponseType.PAYMENT.toString(),
      };
}

final class SelectProductionToLoseResponse implements InputResponse {
  final Units units;
  SelectProductionToLoseResponse({required this.units});
  @override
  Map<String, dynamic> toJson() => {
        'units': units.toJson(),
        'type': ResponseType.PRODUCTION_TO_LOSE.toString(),
      };
}

final class ShiftAresGlobalParametersResponse implements InputResponse {
  final AresGlobalParametersResponse response;
  ShiftAresGlobalParametersResponse({required this.response});
  @override
  Map<String, dynamic> toJson() => {
        'response': response.toJson(),
        'type': ResponseType.ARES_GLOBAL_PARAMETERS.toString(),
      };
}

final class InputResponse {
  factory InputResponse.fromJson({required Map<String, dynamic> json}) {
    ResponseType responseType = ResponseType.fromString(json['responseType']);
    switch (responseType) {
      case ResponseType.OPTION:
        return SelectOptionResponse();
      case ResponseType.OR:
        int index = json['index'];
        InputResponse response = InputResponse.fromJson(json: json['response']);
        return OrOptionsResponse(index: index, response: response);
      case ResponseType.AND:
        List<InputResponse> responses = json['responses']
            .map((response) => InputResponse.fromJson(json: response))
            .toList();
        return AndOptionsResponse(responses: responses);
      case ResponseType.CARD:
        List<CardName> cards =
            json['cards'].map((card) => CardName.fromString(card)).toList();
        return SelectCardResponse(cards: cards);
      case ResponseType.PROJECT_CARD:
        CardName card = CardName.fromString(json['card']);
        Payment payment = Payment.fromJson(json: json['payment']);
        return SelectProjectCardToPlayResponse(card: card, payment: payment);
      case ResponseType.SPACE:
        SpaceId spaceId = SpaceId.fromString(json['spaceId']);
        return SelectSpaceResponse(spaceId: spaceId);
      case ResponseType.PLAYER:
        PlayerColor player = PlayerColor.fromString(json['player']);
        return SelectPlayerResponse(player: player);
      case ResponseType.PARTY:
        PartyName partyName = PartyName.fromString(json['partyName']);
        return SelectPartyResponse(partyName: partyName);
      case ResponseType.DELEGATE:
        PlayerColor player = PlayerColor.fromString(json['player']);
        return SelectDelegateResponse(player: player);
      case ResponseType.AMOUNT:
        int amount = json['amount'];
        return SelectAmountResponse(amount: amount);
      case ResponseType.COLONY:
        ColonyName colonyName = ColonyName.fromString(json['colonyName']);
        return SelectColonyResponse(colonyName: colonyName);
      case ResponseType.PAYMENT:
        Payment payment = Payment.fromJson(json: json['payment']);
        return SelectPaymentResponse(payment: payment);
      case ResponseType.PRODUCTION_TO_LOSE:
        Units units = Units.fromJson(json: json['units']);
        return SelectProductionToLoseResponse(units: units);
      case ResponseType.ARES_GLOBAL_PARAMETERS:
        AresGlobalParametersResponse response =
            AresGlobalParametersResponse.fromJson(json: json['response']);
        return ShiftAresGlobalParametersResponse(response: response);
      default:
        throw Exception('Unknown response type: $responseType');
    }
  }
  Map<String, dynamic> toJson() => {};
}
