import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Resource.dart';
import 'package:mars_flutter/domain/model/Units.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/domain/model/card/Types.dart';
import 'package:mars_flutter/domain/model/logs/Message.dart';

class CardModel extends Equatable {
  final CardName name;
  final int? resources;
  final int? calculatedCost;
  final bool? isSelfReplicatingRobotsCard;
  final List<CardDiscount>? discount;
  final bool? isDisabled; // Used with Pharmacy Union
  final Message? warning;
  final Units?
      reserveUnits; // Written for The Moon, but useful in other contexts.
  final List<Resource>?
      bonusResource; // Used with the Mining cards and Robotic Workforce
  final Tag? cloneTag; // Used with Pathfinders

  CardModel({
    required this.name,
    this.resources,
    this.calculatedCost,
    this.isSelfReplicatingRobotsCard,
    this.discount,
    this.isDisabled,
    this.warning,
    this.reserveUnits,
    this.bonusResource,
    this.cloneTag,
  });

  static fromJson(Map<String, dynamic> json) {
    return CardModel(
      name: CardName.fromString(json['name'] as String),
      resources: json['resources'] as int?,
      calculatedCost: json['calculatedCost'] as int?,
      isSelfReplicatingRobotsCard: json['isSelfReplicatingRobotsCard'] as bool?,
      discount: json['discount'] != null
          ? (json['discount'] as List<dynamic>)
              .map((e) => CardDiscount.fromJson(e as Map<String, dynamic>))
              .cast<CardDiscount>()
              .toList()
          : null,
      isDisabled: json['isDisabled'] as bool?,
      warning: json['warning'] != null
          ? json['warning'].runtimeType == String
              ? Message(message: json['warning'])
              : Message.fromJson(json['warning'])
          : null,
      reserveUnits: json['reserveUnits'] == null
          ? null
          : Units.fromJson(json: json['reserveUnits'] as Map<String, dynamic>),
      bonusResource: json['bonusResource'] != null
          ? (json['bonusResource'])
              .map((e) => Resource.fromString(e as String))
              .cast<Resource>()
              .toList()
          : null,
      cloneTag: json['cloneTag'] == null
          ? null
          : Tag.fromString(json['cloneTag']) as Tag?,
    );
  }

  @override
  List<Object?> get props => [name, resources, calculatedCost, discount];
}
