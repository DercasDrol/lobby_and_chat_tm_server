import 'package:mars_flutter/domain/model/Resource.dart';
import 'package:mars_flutter/domain/model/card/RequirementType.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';

class CardRequirementDescriptor {
  final Tag? tag;
  final int? oxygen;
  final int? temperature;
  final int? greeneries;
  final int? cities;
  final int? oceans;
  final Resource? production;
  final bool? plantsRemoved;
  final int? resourceTypes;
  final int? tr;
  final int? venus;
  final int? floaters;
  final int? colonies;
  final PartyName? party;
  final int? chairman;
  final int? partyLeader;
  final int? habitatTiles;
  final int? miningTiles;
  final int? roadTiles;
  final int? habitatRate;
  final int? miningRate;
  final int? logisticRate;
  final int? excavation;
  final int? corruption;
  final int? count;
  final bool? max;
  final bool? all;
  final bool? nextTo;
  final String? text;

  CardRequirementDescriptor({
    this.tag,
    this.oxygen,
    this.temperature,
    this.greeneries,
    this.cities,
    this.oceans,
    this.production,
    this.plantsRemoved,
    this.resourceTypes,
    this.tr,
    this.venus,
    this.floaters,
    this.colonies,
    this.party,
    this.chairman,
    this.partyLeader,
    this.habitatTiles,
    this.miningTiles,
    this.roadTiles,
    this.habitatRate,
    this.miningRate,
    this.logisticRate,
    this.excavation,
    this.corruption,
    this.count,
    this.max,
    this.all,
    this.nextTo,
    this.text,
  });

  factory CardRequirementDescriptor.fromJson(Map<String, dynamic> json) {
    try {
      return CardRequirementDescriptor(
        tag: json['tag'] == null ? null : Tag.fromString(json['tag']),
        oxygen: json['oxygen'],
        temperature: json['temperature'],
        greeneries: json['greeneries'],
        cities: json['cities'],
        oceans: json['oceans'],
        production: json['production'] == null
            ? null
            : Resource.fromString(json['production']),
        plantsRemoved: json['plantsRemoved'],
        resourceTypes: json['resourceTypes'],
        tr: json['tr'],
        venus: json['venus'],
        floaters: json['floaters'],
        colonies: json['colonies'],
        party:
            json['party'] == null ? null : PartyName.fromString(json['party']),
        chairman: json['chairman'].runtimeType == bool
            ? json['chairman']
                ? 1
                : 0
            : json['chairman'],
        partyLeader: json['partyLeader'],
        habitatTiles: json['habitatTiles'],
        miningTiles: json['miningTiles'],
        roadTiles: json['roadTiles'],
        habitatRate: json['habitatRate'],
        miningRate: json['miningRate'],
        logisticRate: json['logisticRate'],
        excavation: json['excavation'],
        corruption: json['corruption'],
        count: json['count'] ?? 1,
        max: json['max'],
        all: json['all'],
        nextTo: json['nextTo'],
        text: json['text'],
      );
    } catch (e) {
      throw Exception('Error parsing CardRequirementDescriptor: $json');
    }
  }

  RequirementType get requirementType {
    if (tag != null) {
      return RequirementType.TAG;
    } else if (oceans != null) {
      return RequirementType.OCEANS;
    } else if (oxygen != null) {
      return RequirementType.OXYGEN;
    } else if (temperature != null) {
      return RequirementType.TEMPERATURE;
    } else if (venus != null) {
      return RequirementType.VENUS;
    } else if (tr != null) {
      return RequirementType.TR;
    } else if (chairman != null) {
      return RequirementType.CHAIRMAN;
    } else if (resourceTypes != null) {
      return RequirementType.RESOURCE_TYPES;
    } else if (greeneries != null) {
      return RequirementType.GREENERIES;
    } else if (cities != null) {
      return RequirementType.CITIES;
    } else if (colonies != null) {
      return RequirementType.COLONIES;
    } else if (floaters != null) {
      return RequirementType.FLOATERS;
    } else if (partyLeader != null) {
      return RequirementType.PARTY_LEADERS;
    } else if (production != null) {
      return RequirementType.PRODUCTION;
    } else if (party != null) {
      return RequirementType.PARTY;
    } else if (plantsRemoved != null) {
      return RequirementType.REMOVED_PLANTS;
    } else if (habitatRate != null) {
      return RequirementType.HABITAT_RATE;
    } else if (miningRate != null) {
      return RequirementType.MINING_RATE;
    } else if (logisticRate != null) {
      return RequirementType.LOGISTIC_RATE;
    } else if (habitatTiles != null) {
      return RequirementType.HABITAT_TILES;
    } else if (miningTiles != null) {
      return RequirementType.MINING_TILES;
    } else if (roadTiles != null) {
      return RequirementType.ROAD_TILES;
    } else if (excavation != null) {
      return RequirementType.EXCAVATION;
    } else if (corruption != null) {
      return RequirementType.CORRUPTION;
    } else {
      throw Exception('Unknown requirement: $this');
    }
  }
}
