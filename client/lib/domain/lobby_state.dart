import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/player.dart';

enum LobbyStatus { LOADING, SUCCESS, FAILURE }

enum GameActionType {
  SHOW_OPTIONS,
  SHOW_PLAYER_GAME,
  SHOW_SPECTATOR_GAME;

  bool get isGoToGame => [SHOW_PLAYER_GAME, SHOW_SPECTATOR_GAME].contains(this);
}

class LobbyState extends Equatable {
  final LobbyStatus status;
  final Map<int /*lobbyGameId*/, LobbyGame>? gamesList;
  final Map<int /*lobbyGameId*/, Player>? playersList;
  final int? gameIdToAction;
  final GameActionType? gameActionType;

  const LobbyState._({
    this.status = LobbyStatus.LOADING,
    this.gamesList = null,
    this.gameIdToAction = null,
    this.gameActionType = null,
    this.playersList = null,
  });

  const LobbyState.loading() : this._();

  const LobbyState.success(
    Map<int, LobbyGame>? newGamesList,
    int? gameIdForChanges,
    GameActionType? gameActionType,
    Map<int, Player>? playersList,
  ) : this._(
          status: LobbyStatus.SUCCESS,
          gamesList: newGamesList,
          gameIdToAction: gameIdForChanges,
          gameActionType: gameActionType,
          playersList: playersList,
        );

  const LobbyState.failure(
    Map<int, LobbyGame>? gamesList,
    int? gameIdForChanges,
    GameActionType? gameActionType,
    Map<int, Player>? playersList,
  ) : this._(
          status: LobbyStatus.FAILURE,
          gamesList: gamesList,
          gameIdToAction: gameIdForChanges,
          gameActionType: gameActionType,
          playersList: playersList,
        );

  @override
  List<Object?> get props => [
        status,
        gamesList.hashCode,
        gameIdToAction,
        gameActionType,
        playersList.hashCode,
      ];
}
