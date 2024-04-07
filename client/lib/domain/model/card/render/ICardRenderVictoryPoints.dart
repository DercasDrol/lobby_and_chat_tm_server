import 'CardComponents.dart';

abstract class ICardRenderVictoryPoints {
  final int points;
  ICardRenderVictoryPoints({required this.points});
}

class ICardRenderDynamicVictoryPoints implements ICardRenderVictoryPoints {
  ICardRenderItem? item;
  @override
  int points;
  int target;
  bool targetOneOrMore;
  bool anyPlayer;
  ICardRenderDynamicVictoryPoints({
    this.item,
    required this.points,
    required this.target,
    required this.targetOneOrMore,
    required this.anyPlayer,
  });

  factory ICardRenderDynamicVictoryPoints.fromJson(json) {
    return ICardRenderDynamicVictoryPoints(
      item:
          json['item'] == null ? null : ICardRenderItem.fromJson(json['item']),
      points: json['points'],
      target: json['target'],
      targetOneOrMore: json['targetOneOrMore'],
      anyPlayer: json['anyPlayer'],
    );
  }
}

class ICardRenderStaticVictoryPoints implements ICardRenderVictoryPoints {
  @override
  int points;
  ICardRenderStaticVictoryPoints({
    required this.points,
  });
  factory ICardRenderStaticVictoryPoints.fromJson(json) {
    return ICardRenderStaticVictoryPoints(
      points: json,
    );
  }
}
