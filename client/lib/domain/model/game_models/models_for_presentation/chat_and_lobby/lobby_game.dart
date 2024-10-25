import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Phase.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/domain/model/game_models/GameModel.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';

class LobbyGame extends Equatable {
  final int lobbyGameId;
  final GameModel? gameModel;
  final CreateGameModel createGameModel;
  final DateTime createdAt;
  final DateTime? deathAt;
  final DateTime? sharedAt;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final ViewModel? finalState;
  final String userIdCreatedBy;
  final SpectatorId? spectatorId;

  LobbyGame({
    required this.lobbyGameId,
    required this.gameModel,
    required this.createGameModel,
    required this.createdAt,
    this.deathAt,
    this.sharedAt,
    this.startedAt,
    this.finishedAt,
    this.finalState,
    required this.userIdCreatedBy,
    this.spectatorId,
  });

  factory LobbyGame.fromJson(Map<String, dynamic> e) {
    final gameConfig =
        NewGameConfig.fromJson(e['newGameConfig'] as Map<String, dynamic>);
    return LobbyGame(
      lobbyGameId: e['lobbyGameId'] as int,
      gameModel: e['gameModel'] == null
          ? null
          : GameModel.fromJson(e['gameModel'] as Map<String, dynamic>),
      createGameModel: CreateGameModel.fromGameConfig(gameConfig),
      createdAt: DateTime.parse(e['createdAt'] as String),
      deathAt: e['deathDay'] == null
          ? null
          : DateTime.parse(e['deathDay'] as String),
      sharedAt: e['sharedAt'] == null
          ? null
          : DateTime.parse(e['sharedAt'] as String),
      startedAt: e['startedAt'] == null
          ? null
          : DateTime.parse(e['startedAt'] as String),
      finishedAt: e['finishedAt'] == null
          ? null
          : DateTime.parse(e['finishedAt'] as String),
      finalState: e['finalState'] == null
          ? null
          : ViewModel.fromJson(jsonDecode(e['finalState'] as String)),
      userIdCreatedBy: e['userIdCreatedBy'] as String,
      spectatorId: e['spectatorId'] == null
          ? null
          : SpectatorId.fromString(e['spectatorId'] as String),
    );
  }

  get isSharedGame => this.sharedAt != null;

  String toShortJson() {
    return '''{"lobbyGameid":$lobbyGameId,"newGameConfig":${jsonEncode(NewGameConfig.fromCreateGameModel(createGameModel).toJson())},"userIdCreatedBy":"$userIdCreatedBy"}''';
  }

  bool get isPlayerCanJoin {
    return createGameModel.players.length < createGameModel.maxPlayers;
  }

  bool get isDead {
    return deathAt != null
        ? deathAt!.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch
        : false;
  }

  bool isPlayerJoined(String? userId) {
    return createGameModel.players.any((element) => element.userId == userId);
  }

  bool get isStarted {
    return startedAt != null;
  }

  bool get isFinished {
    return finishedAt != null || finalState?.game.phase == Phase.END;
  }

  @override
  List<Object?> get props => [
        lobbyGameId,
        gameModel,
        createGameModel,
        createdAt,
        sharedAt,
        startedAt,
        finishedAt,
        finalState,
        userIdCreatedBy,
        spectatorId,
      ];

  LobbyGame copyWith({
    int? lobbyGameid,
    GameModel? gameModel,
    CreateGameModel? createGameModel,
    DateTime? createdAt,
    DateTime? sharedAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    ViewModel? finalState,
    String? userIdCreatedBy,
    SpectatorId? spectatorId,
  }) {
    return LobbyGame(
      lobbyGameId: lobbyGameid ?? this.lobbyGameId,
      gameModel: gameModel ?? this.gameModel,
      createGameModel: createGameModel ?? this.createGameModel,
      createdAt: createdAt ?? this.createdAt,
      sharedAt: sharedAt ?? this.sharedAt,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      finalState: finalState ?? this.finalState,
      userIdCreatedBy: userIdCreatedBy ?? this.userIdCreatedBy,
      spectatorId: spectatorId ?? this.spectatorId,
    );
  }
}
