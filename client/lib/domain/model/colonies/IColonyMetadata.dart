import 'package:mars_flutter/domain/model/CardResouce.dart';
import 'package:mars_flutter/domain/model/Resource.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyBenefit.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';

/**
export interface IColonyMetadata {
  module?: GameModule; // TODO(kberg): attach gameModule to the server colonies themselves.
  readonly name: ColonyName;
  readonly buildType: ColonyBenefit;
  readonly buildQuantity: Array<number>; // Default is [1,1,1]
  readonly buildResource?: Resource;
  readonly cardResource?: CardResource;
  readonly tradeType: ColonyBenefit;
  readonly tradeQuantity: Array<number>; // Default is [1,1,1,1,1,1,1]
  readonly tradeResource?: Resource | Array<Resource>;
  readonly colonyBonusType: ColonyBenefit;
  readonly colonyBonusQuantity: number; // Default is 1
  readonly colonyBonusResource?: Resource;
  readonly shouldIncreaseTrack: 'yes' | 'no' | 'ask' // Default is 'yes';
}

export type IInputColonyMetadata = Omit<IColonyMetadata, 'buildQuantity' |'tradeQuantity' | 'colonyBonusQuantity' | 'shouldIncreaseTrack'> & Partial<IColonyMetadata>;

const DEFAULT_BUILD_QUANTITY = [1, 1, 1];
const DEFAULT_TRADE_QUANTITY = [1, 1, 1, 1, 1, 1, 1];

export function colonyMetadata(partial: IInputColonyMetadata): IColonyMetadata {
  return {
    buildQuantity: DEFAULT_BUILD_QUANTITY,
    tradeQuantity: DEFAULT_TRADE_QUANTITY,
    colonyBonusQuantity: 1,
    shouldIncreaseTrack: 'yes',
    ...partial,
  };
} */
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

abstract class IColonyMetadata {
  final GameModule? module;
  final ColonyName name;
  final ColonyBenefit buildType;
  final List<int> buildQuantity;
  final Resource? buildResource;
  final CardResource? cardResource;
  final ColonyBenefit tradeType;
  final List<int> tradeQuantity;
  final Resource? tradeResource;
  final ColonyBenefit colonyBonusType;
  final int colonyBonusQuantity;
  final Resource? colonyBonusResource;
  final ShouldIncreaseTrack shouldIncreaseTrack;

  IColonyMetadata({
    this.module,
    required this.name,
    required this.buildType,
    required this.buildQuantity,
    this.buildResource,
    this.cardResource,
    required this.tradeType,
    required this.tradeQuantity,
    this.tradeResource,
    required this.colonyBonusType,
    required this.colonyBonusQuantity,
    this.colonyBonusResource,
    required this.shouldIncreaseTrack,
  });
}
