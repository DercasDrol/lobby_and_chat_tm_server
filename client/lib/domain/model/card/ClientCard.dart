// ignore_for_file: sdk_version_since

import '../CardResouce.dart';
import '../Units.dart';
import '../logs/Message.dart';
import 'CardName.dart';
import 'CardType.dart';
import 'GameModule.dart';
import 'ICardMetadata.dart';
import 'ICardRequirements.dart';
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
  ICardRequirements? requirements;
  ICardMetadata metadata;
  Message? warning;
  Units? productionBox;
  CardResource? resourceType;
  int? startingMegaCredits; // Corporation and Prelude
  int? cardCost; // Corporation
  List<GameModule> compatibility;
  factory ClientCard.fromJson(value) {
    final List<GameModule> compatibility = value['compatibility'] == null
        ? <GameModule>[]
        : value['compatibility']
            .map((e) => GameModule.fromString(e))
            .cast<GameModule>()
            .toList();
    final List<Tag> tags = value['tags'] == List.empty()
        ? <Tag>[]
        : value['tags'].map((e) => Tag.fromString(e)).cast<Tag>().toList();
    ;
    final List<CardDiscount>? cardDiscount = value['cardDiscount'] == null
        ? null
        : value['cardDiscount'] == List.empty()
            ? <CardDiscount>[]
            : value['cardDiscount'].runtimeType == List
                ? value['cardDiscount']
                    .map((e) => CardDiscount.fromJson(e))
                    .cast<CardDiscount>()
                    .toList()
                : <CardDiscount>[CardDiscount.fromJson(value['cardDiscount'])];
    final ICardRequirements? requirements = value['requirements'] == null
        ? null
        : ICardRequirements.fromJson(value['requirements']);

    return ClientCard(
      name: CardName.fromString(value['name']),
      module: GameModule.fromString(value['module']),
      tags: tags,
      cardDiscount: cardDiscount,
      cost: value['cost'] == null ? null : value['cost'],
      type: CardType.fromString(value['type']),
      requirements: requirements,
      metadata: ICardMetadata.fromJson(value['metadata']),
      warning:
          value['warning'] != null ? Message.fromJson(value['warning']) : null,
      productionBox: Units.fromJson(json: value['productionBox']),
      resourceType: value['resourceType'] != null
          ? CardResource.fromString(value['resourceType'])
          : null,
      startingMegaCredits: value['startingMegaCredits'],
      cardCost: value['cardCost'],
      compatibility: compatibility,
    );
  }
  ClientCard({
    required this.name,
    required this.module,
    required this.tags,
    this.cardDiscount,
    this.cost,
    required this.type,
    this.requirements,
    required this.metadata,
    this.warning,
    this.productionBox,
    this.resourceType,
    this.startingMegaCredits,
    this.cardCost,
    required this.compatibility,
  });

  static Map<CardName, ClientCard> _clientCards = {};
  static List<ClientCard> get allCards => _clientCards.values.toList();
  static set allCards(List<ClientCard> value) {
    _clientCards = Map.fromIterable(
      value,
      key: (card) => (card as ClientCard).name,
      value: (card) => card,
    );
  }

  factory ClientCard.fromCardName(CardName cardName) {
    return _clientCards[cardName]!;
  }
}
