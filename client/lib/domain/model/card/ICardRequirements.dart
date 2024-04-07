import 'ICardRequirement.dart';

class ICardRequirements {
  List<ICardRequirement> requirements;
  ICardRequirements({required this.requirements});
  factory ICardRequirements.fromJson(json) {
    return ICardRequirements(
      requirements: json['requirements'] == null
          ? <ICardRequirement>[]
          : json['requirements']
              .map((e) => ICardRequirement.fromJson(e))
              .cast<ICardRequirement>()
              .toList(),
    );
  }
}
