import 'dart:async';

import 'package:mars_flutter/domain/model/CardResouce.dart';
import 'package:mars_flutter/domain/model/Resource.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyBenefit.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';

enum ShouldIncreaseTrack {
  YES,
  NO,
  ASK;

  static const _TO_STRING_MAP = {
    YES: 'yes',
    NO: 'no',
    ASK: 'ask',
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}

class IColonyMetadata {
  final GameModule module;
  final ColonyName name;
  final List<String> description;
  final ColonyBenefit buildType;
  final List<int> buildQuantity;
  final Resource? buildResource;
  final CardResource? cardResource;
  final ColonyBenefit tradeType;
  final List<int> tradeQuantity;
  final List<Resource>? tradeResource;
  final ColonyBenefit colonyBonusType;
  final int colonyBonusQuantity;
  final Resource? colonyBonusResource;
  final ShouldIncreaseTrack shouldIncreaseTrack;
  static const _DEFAULT_BUILD_QUANTITY = [1, 1, 1];
  static const _DEFAULT_TRADE_QUANTITY = [1, 1, 1, 1, 1, 1, 1];

  IColonyMetadata({
    required this.module,
    required this.name,
    required this.description,
    required this.buildType,
    this.buildQuantity = _DEFAULT_BUILD_QUANTITY,
    this.buildResource,
    this.cardResource,
    required this.tradeType,
    this.tradeQuantity = _DEFAULT_TRADE_QUANTITY,
    this.tradeResource,
    required this.colonyBonusType,
    required this.colonyBonusQuantity,
    this.colonyBonusResource,
    this.shouldIncreaseTrack = ShouldIncreaseTrack.YES,
  });

  factory IColonyMetadata.fromJson(Map<String, dynamic> json) {
    try {
      return IColonyMetadata(
        module: GameModule.fromJson(json['module']),
        name: ColonyName.fromString(json['name']),
        description: List<String>.from(json['description']),
        buildType: ColonyBenefit.values[json['buildType']],
        buildQuantity:
            List<int>.from(json['buildQuantity'] ?? _DEFAULT_BUILD_QUANTITY),
        buildResource: json['buildResource'] != null
            ? Resource.fromString(json['buildResource'])
            : null,
        cardResource: json['cardResource'] != null
            ? CardResource.fromString(json['cardResource'])
            : null,
        tradeType: ColonyBenefit.values[json['tradeType']],
        tradeQuantity:
            List<int>.from(json['tradeQuantity'] ?? _DEFAULT_TRADE_QUANTITY),
        tradeResource: json['tradeResource'] != null
            ? (json['tradeResource'].runtimeType == String)
                ? [Resource.fromString(json['tradeResource'])]
                : List<Resource>.from(
                    json['tradeResource']
                        .map((resource) => Resource.fromString(resource)),
                  )
            : null,
        colonyBonusType: ColonyBenefit.values[json['colonyBonusType']],
        colonyBonusQuantity: json['colonyBonusQuantity'],
        colonyBonusResource: json['colonyBonusResource'] != null
            ? Resource.fromString(json['colonyBonusResource'])
            : null,
        shouldIncreaseTrack: ShouldIncreaseTrack.fromString(
            json['shouldIncreaseTrack'] ?? 'yes'),
      );
    } catch (e) {
      throw ('IColonyMetadata.fromJson: $json', e);
    }
  }

  static final Completer<Map<ColonyName, IColonyMetadata>> _completer =
      new Completer();
  static Map<ColonyName, IColonyMetadata> _coloniesMetadata = Map();
  static Future<Map<ColonyName, IColonyMetadata>> get allColoniesMetadata =>
      _completer.future;
  static setAllColoniesMetadata(List<IColonyMetadata> value) {
    _coloniesMetadata = Map.fromIterable(
      value,
      key: (colony) => (colony as IColonyMetadata).name,
      value: (colony) => colony,
    );
    _completer.complete(_coloniesMetadata);
  }

  factory IColonyMetadata.fromCardName(ColonyName colonyName) {
    try {
      return _coloniesMetadata[colonyName]!;
    } catch (e) {
      throw ('IColonyMetadata.fromCardName: $colonyName', e);
    }
  }
}
