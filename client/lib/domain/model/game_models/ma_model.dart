import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/ma/AwardName.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAward.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneName.dart';
import 'package:mars_flutter/domain/model/ma/ma_score.dart';

abstract class MaModel {
  final MilestoneAwardName name;
  final String playerName;
  final PlayerColor? playerColor;
  final List<MaScore> scores;

  MaModel({
    required this.name,
    required this.playerName,
    required this.playerColor,
    required this.scores,
  });
}

class FundedAwardModel implements MaModel {
  final AwardName name;
  final String playerName;
  final PlayerColor? playerColor;
  final List<MaScore> scores;

  FundedAwardModel({
    required this.name,
    required this.playerName,
    required this.playerColor,
    required this.scores,
  });

  static FundedAwardModel fromJson(Map<String, dynamic> json) {
    return FundedAwardModel(
      name: AwardName.fromString(json['name'] as String),
      playerName: json['playerName'] as String,
      playerColor: (json['playerColor'] == null || json['playerColor'] == '')
          ? null
          : PlayerColor.fromString(json['playerColor'] as String),
      scores: (json['scores'] as List<dynamic>)
          .map((e) => MaScore(
                color: PlayerColor.fromString(e['playerColor'] as String) ??
                    PlayerColor.NEUTRAL,
                number: e['playerScore'] as int,
              ))
          .toList(),
    );
  }
}

class ClaimedMilestoneModel implements MaModel {
  final MilestoneName name;
  final String playerName;
  final PlayerColor? playerColor;
  final List<MaScore> scores;

  ClaimedMilestoneModel({
    required this.name,
    required this.playerName,
    required this.playerColor,
    required this.scores,
  });

  static ClaimedMilestoneModel fromJson(Map<String, dynamic> json) {
    return ClaimedMilestoneModel(
      name: MilestoneName.fromString(json['name'] as String),
      playerName: json['playerName'] as String,
      playerColor: PlayerColor.fromString(json['playerColor'] as String),
      scores: (json['scores'] as List<dynamic>)
          .map((e) => MaScore(
                color: PlayerColor.fromString(e['playerColor'] as String) ??
                    PlayerColor.NEUTRAL,
                number: e['playerScore'] as int,
              ))
          .toList(),
    );
  }
}
