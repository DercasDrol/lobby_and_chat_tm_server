// ignore_for_file: sdk_version_since

import 'dart:async';

import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/model/card/CardRequirementDescriptor.dart';

import '../CardResouce.dart';
import '../Units.dart';
import '../logs/Message.dart';
import 'CardName.dart';
import 'CardType.dart';
import 'GameModule.dart';
import 'ICardMetadata.dart';
import 'Tag.dart';
import 'Types.dart';

class ClientCard {
  CardName name;
  GameModule module;
  List<Tag> tags;
  List<CardDiscount>? cardDiscount;
  //Mayby this needn't on client side, see it later
  //victoryPoints?: number | 'special' | IVictoryPoints,
  int? cost;
  CardType type;
  List<CardRequirementDescriptor> requirements;
  ICardMetadata metadata;
  Message? warning;
  Units? productionBox;
  CardResource? resourceType;
  int? startingMegaCredits; // Corporation and Prelude
  int? cardCost; // Corporation
  List<GameModule> compatibility;
  factory ClientCard.fromJson(value) {
    try {
      final List<GameModule> compatibility = value['compatibility'] == null
          ? <GameModule>[]
          : value['compatibility']
              .map((e) => GameModule.fromString(e))
              .cast<GameModule>()
              .toList();
      final List<Tag> tags = value['tags'] == List.empty()
          ? <Tag>[]
          : value['tags'].map((e) => Tag.fromString(e)).cast<Tag>().toList();

      final List<CardDiscount>? cardDiscount = value['cardDiscount'] == null
          ? null
          : value['cardDiscount'] == List.empty()
              ? <CardDiscount>[]
              : value['cardDiscount'].runtimeType == [].runtimeType
                  ? value['cardDiscount']
                      .map((e) => CardDiscount.fromJson(e))
                      .cast<CardDiscount>()
                      .toList()
                  : <CardDiscount>[
                      CardDiscount.fromJson(value['cardDiscount'])
                    ];
      final List<CardRequirementDescriptor> requirements =
          value['requirements'] == null ||
                  value['requirements'].runtimeType != [].runtimeType
              ? []
              : value['requirements']
                  .map((e) => CardRequirementDescriptor.fromJson(e))
                  .cast<CardRequirementDescriptor>()
                  .toList();
      final cardName = CardName.fromString(value['name']);
      if (cardName == CardName.UNKNOWN) {
        logger.d('Unknown card name: ${value['name']}');
      }

      return ClientCard(
        name: cardName,
        module: GameModule.fromString(value['module']),
        tags: tags,
        cardDiscount: cardDiscount,
        cost: value['cost'] == null ? null : value['cost'],
        type: CardType.fromString(value['type']),
        requirements: requirements,
        metadata: ICardMetadata.fromJson(value['metadata']),
        warning: value['warning'] != null
            ? value['warning'].runtimeType == String
                ? Message(message: value['warning'])
                : Message.fromJson(value['warning'])
            : null,
        productionBox: Units.fromJson(json: value['productionBox']),
        resourceType: value['resourceType'] != null
            ? CardResource.fromString(value['resourceType'])
            : null,
        startingMegaCredits: value['startingMegaCredits'],
        cardCost: value['cardCost'],
        compatibility: compatibility,
      );
    } catch (e) {
      logger.d(e);
      logger.d(value);
      rethrow;
    }
  }
  ClientCard({
    required this.name,
    required this.module,
    required this.tags,
    this.cardDiscount,
    this.cost,
    required this.type,
    required this.requirements,
    required this.metadata,
    this.warning,
    this.productionBox,
    this.resourceType,
    this.startingMegaCredits,
    this.cardCost,
    required this.compatibility,
  });

  static final Completer<Map<CardName, ClientCard>> _completer =
      new Completer();
  static Map<CardName, ClientCard> _clientCards = Map();
  static Future<Map<CardName, ClientCard>> get allCards => _completer.future;
  static setAllCards(List<ClientCard> value) {
    _clientCards = Map.fromIterable(
      value,
      key: (card) => (card as ClientCard).name,
      value: (card) => card,
    );
    _completer.complete(_clientCards);
  }

  factory ClientCard.fromCardName(CardName cardName) {
    return _clientCards[cardName]!;
  }

  bool get isCorp => type == CardType.CORPORATION;
}
