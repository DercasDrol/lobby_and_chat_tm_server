import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game_template.dart';
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
  final Map<int /*tempateId*/, LobbyGameTemplate>? gameTemplatesList;
  final Map<int /*lobbyGameId*/, Player>? playersList;
  final int? gameIdToAction;
  final int? selectedTemplateId;
  final GameActionType? gameActionType;
  final String? notification;

  const LobbyState._({
    this.status = LobbyStatus.LOADING,
    this.gamesList = null,
    this.gameTemplatesList = null,
    this.gameIdToAction = null,
    this.selectedTemplateId = null,
    this.gameActionType = null,
    this.playersList = null,
    this.notification = null,
  });

  const LobbyState.loading() : this._();

  const LobbyState.success(
    Map<int, LobbyGame>? newGamesList,
    Map<int, LobbyGameTemplate>? gameTemplatesList,
    int? gameIdForChanges,
    int? selectedTemplateId,
    GameActionType? gameActionType,
    Map<int, Player>? playersList,
    String? notification,
  ) : this._(
          status: LobbyStatus.SUCCESS,
          gamesList: newGamesList,
          gameTemplatesList: gameTemplatesList,
          gameIdToAction: gameIdForChanges,
          selectedTemplateId: selectedTemplateId,
          gameActionType: gameActionType,
          playersList: playersList,
          notification: notification,
        );

  const LobbyState.failure(
    Map<int, LobbyGame>? gamesList,
    Map<int, LobbyGameTemplate>? gameTemplatesList,
    int? gameIdForChanges,
    int? selectedTemplateId,
    GameActionType? gameActionType,
    Map<int, Player>? playersList,
    String? notification,
  ) : this._(
          status: LobbyStatus.FAILURE,
          gamesList: gamesList,
          gameTemplatesList: gameTemplatesList,
          gameIdToAction: gameIdForChanges,
          selectedTemplateId: selectedTemplateId,
          gameActionType: gameActionType,
          playersList: playersList,
          notification: notification,
        );

  @override
  List<Object?> get props => [
        status,
        gamesList.hashCode,
        gameTemplatesList.hashCode,
        gameIdToAction,
        selectedTemplateId,
        gameActionType,
        playersList.hashCode,
        notification,
      ];
}
