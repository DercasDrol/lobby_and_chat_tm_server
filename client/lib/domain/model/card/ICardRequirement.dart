import '../Resource.dart';
import '../turmoil/PartyName.dart';
import 'RequirementType.dart';
import 'Tag.dart';

class ICardRequirement {
  RequirementType type;
  int amount;
  bool isMax;
  bool isAny;
  ICardRequirement(
      {required this.type,
      required this.amount,
      required this.isMax,
      required this.isAny});
  factory ICardRequirement.fromJson(Map<String, dynamic> json) {
    switch (RequirementType.fromString(json['type'])) {
      case RequirementType.PARTY:
        return IPartyCardRequirement.fromJson(json);
      case RequirementType.PRODUCTION:
        return IProductionCardRequirement.fromJson(json);
      case RequirementType.TAG:
        return ITagCardRequirement.fromJson(json);
      default:
        return ICardRequirement(
          type: RequirementType.fromString(json['type']),
          amount: json['amount'] ?? 0,
          isMax: json['isMax'] ?? false,
          isAny: json['isAny'] ?? false,
        );
    }
  }
}

class IPartyCardRequirement extends ICardRequirement {
  PartyName party;
  IPartyCardRequirement(
      {required this.party,
      required super.type,
      required super.amount,
      required super.isMax,
      required super.isAny});
  factory IPartyCardRequirement.fromJson(Map<String, dynamic> json) {
    return IPartyCardRequirement(
      party: PartyName.fromString(json['party']),
      type: RequirementType.fromString(json['type']),
      amount: json['amount'] ?? 0,
      isMax: json['isMax'] ?? false,
      isAny: json['isAny'] ?? false,
    );
  }
}

class IProductionCardRequirement extends ICardRequirement {
  Resource resource;
  IProductionCardRequirement(
      {required this.resource,
      required super.type,
      required super.amount,
      required super.isMax,
      required super.isAny});
  factory IProductionCardRequirement.fromJson(Map<String, dynamic> json) {
    return IProductionCardRequirement(
      resource: Resource.fromString(json['resource']),
      type: RequirementType.fromString(json['type']),
      amount: json['amount'] ?? 0,
      isMax: json['isMax'] ?? false,
      isAny: json['isAny'] ?? false,
    );
  }
}

class ITagCardRequirement extends ICardRequirement {
  Tag tag;
  ITagCardRequirement(
      {required this.tag,
      required super.type,
      required super.amount,
      required super.isMax,
      required super.isAny});
  factory ITagCardRequirement.fromJson(Map<String, dynamic> json) {
    return ITagCardRequirement(
      tag: Tag.fromString(json['tag']),
      type: RequirementType.fromString(json['type']),
      amount: json['amount'] ?? 0,
      isMax: json['isMax'] ?? false,
      isAny: json['isAny'] ?? false,
    );
  }
}
