import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Phase.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game_models/GameOptionsModel.dart';

class SimpleGameModel {
  final PlayerColor activePlayer;
  final GameId id;
  final Phase phase;
  final List<SimplePlayerModel> players;
  final SpectatorId? spectatorId;
  final GameOptionsModel gameOptions;
  final int lastSoloGeneration;
  final int expectedPurgeTimeMs;

  SimpleGameModel({
    required this.activePlayer,
    required this.id,
    required this.phase,
    required this.players,
    this.spectatorId,
    required this.gameOptions,
    required this.lastSoloGeneration,
    required this.expectedPurgeTimeMs,
  });

  @override
  SimpleGameModel.fromJson(Map<String, dynamic> json)
      : activePlayer = PlayerColor.fromString(json['activePlayer'] as String) ??
            PlayerColor.NEUTRAL,
        id = GameId.fromString(json['id'] as String),
        phase = Phase.fromString(json['phase'] as String),
        players = (json['players'] as List<dynamic>)
            .map((e) => SimplePlayerModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        spectatorId = json['spectatorId'] == null
            ? null
            : SpectatorId.fromString(json['spectatorId'] as String),
        gameOptions = GameOptionsModel.fromJson(
            json['gameOptions'] as Map<String, dynamic>),
        lastSoloGeneration = json['lastSoloGeneration'] as int,
        expectedPurgeTimeMs = json['expectedPurgeTimeMs'] as int;
}

class SimplePlayerModel {
  final PlayerColor color;
  final PlayerId id;
  final String name;

  SimplePlayerModel({
    required this.color,
    required this.id,
    required this.name,
  });

  SimplePlayerModel.fromJson(Map<String, dynamic> e)
      : color =
            PlayerColor.fromString(e['color'] as String) ?? PlayerColor.NEUTRAL,
        id = PlayerId.fromString(e['id'] as String),
        name = e['name'] as String;
}
