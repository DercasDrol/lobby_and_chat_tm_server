import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';

class ColonyModel {
  List<PlayerColor> colonies;
  bool isActive;
  ColonyName name;
  int trackPosition;
  PlayerColor? visitor;

  ColonyModel({
    required this.colonies,
    required this.isActive,
    required this.name,
    required this.trackPosition,
    this.visitor,
  });

  static ColonyModel fromJson(Map<String, dynamic> json) {
    return ColonyModel(
      colonies: json['colonies']
          .map((e) => PlayerColor.fromString(e as String))
          .toList(),
      isActive: json['isActive'] as bool,
      name: ColonyName.fromString(json['name'] as String),
      trackPosition: json['trackPosition'] as int,
      visitor: json['visitor'] == null
          ? null
          : PlayerColor.fromString(json['visitor'] as String),
    );
  }
}
