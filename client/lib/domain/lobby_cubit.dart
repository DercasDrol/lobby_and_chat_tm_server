// ignore_for_file: sdk_version_since

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/lobby/lobby_api_client.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/player.dart';

class LobbyCubit extends Cubit<LobbyState> {
  final LobbyAPIClient lobbyRepository;
  LobbyCubit(this.lobbyRepository) : super(const LobbyState.loading());
  String? get userId => lobbyRepository.userId;
  bool get needGoToGame {
    final targetGame = state.gamesList?[state.gameIdToAction];
    return (state.gameActionType?.isGoToGame ?? false) &&
        (state.playersList?[state.gameIdToAction] != null ||
            targetGame?.spectatorId != null);
  }

  PlayerId? get playerId => state.playersList?[state.gameIdToAction]?.playerId;
  ParticipantId? get participantId {
    final targetGame = state.gamesList?[state.gameIdToAction];
    return playerId != null && state.gameActionType?.isGoToGame != null
        ? playerId
        : state.gameActionType?.isGoToGame != null
            ? targetGame?.spectatorId
            : null;
  }

  void init() {
    lobbyRepository.subscribeOnNewGames(
      (Map<int /*LobbyGame.id*/, LobbyGame> gamesFromServer) {
        final currentUserId = userId;
        final newGamesList =
            new Map<int, LobbyGame>.from(state.gamesList ?? {});
        newGamesList.addAll(gamesFromServer);
        logger.d('LobbyCubit triggered currentUserId: $currentUserId');
        logger.d('LobbyCubit triggered: $gamesFromServer');
        GameActionType? gameActionType = state.gameActionType;
        final newGameIdToShowInLobby =
            newGamesList.values.fold<int?>(null, (acc, game) {
          final isItCurrentUserGame = game.userIdCreatedBy == currentUserId;
          final isItStarted = game.startedAt != null;
          final isCurrentUserJoined = game.createGameModel.players
              .any((player) => player.userId == currentUserId);
          if (isCurrentUserJoined &&
              isItStarted &&
              state.gameIdToAction == game.lobbyGameId) {
            gameActionType = GameActionType.SHOW_PLAYER_GAME;
            if (state.playersList?[game.lobbyGameId] == null)
              lobbyRepository.loadPlayer(game.lobbyGameId);
          }
          final isPlayerInGame = state.gameActionType?.isGoToGame ?? false;
          return ((isItCurrentUserGame || isCurrentUserJoined) &&
                      !isItStarted &&
                      !isPlayerInGame) ||
                  gameActionType != null &&
                      game.lobbyGameId == state.gameIdToAction
              ? game.lobbyGameId
              : acc;
        });

        emit(
          LobbyState.success(
            newGamesList,
            newGameIdToShowInLobby,
            gameActionType,
            state.playersList,
          ),
        );
      },
    );

    lobbyRepository.subscribeOnDeleteGame((lobbyGameId) {
      final newGamesList = new Map<int, LobbyGame>.from(state.gamesList ?? {});
      newGamesList.remove(lobbyGameId);
      final gameIdToShowGameOptions =
          lobbyGameId == state.gameIdToAction ? null : state.gameIdToAction;
      emit(LobbyState.success(
        newGamesList,
        gameIdToShowGameOptions,
        state.gameActionType,
        state.playersList,
      ));
    });

    lobbyRepository.subscribeOnPlayers((Player player) {
      final newPlayersList = new Map<int, Player>.from(state.playersList ?? {});
      newPlayersList[player.lobbyGameId] = player;
      emit(LobbyState.success(
        state.gamesList,
        state.gameIdToAction,
        state.gameActionType,
        newPlayersList,
      ));
    });

    lobbyRepository.isLobbyConnectionOk.addListener(() {
      if (!lobbyRepository.isLobbyConnectionOk.value) {
        emit(LobbyState.failure(
          state.gamesList,
          state.gameIdToAction,
          state.gameActionType,
          state.playersList,
        ));
      }
    });
    lobbyRepository.loadGames();
  }

  void startNewGame(int lobbyGameId) {
    lobbyRepository.startNewGame(lobbyGameId);
  }

  void publicNewGame(int lobbyGameId) {
    lobbyRepository.publishNewGame(lobbyGameId);
  }

  void deleteGame(int lobbyGameId) {
    lobbyRepository.deleteGame(lobbyGameId);
    final newGamesList = new Map<int, LobbyGame>.from(state.gamesList ?? {});
    newGamesList.remove(lobbyGameId);
    emit(LobbyState.success(
      newGamesList,
      null,
      state.gameActionType,
      state.playersList,
    ));
  }

  void joinNewGame(int lobbyGameId) {
    lobbyRepository.joinNewGame(lobbyGameId);
  }

  void leaveNewGame(int lobbyGameId) {
    lobbyRepository.leaveNewGame(lobbyGameId);
  }

  void continueGame(int lobbyGameId) {
    if (state.playersList?[lobbyGameId] == null)
      lobbyRepository.loadPlayer(lobbyGameId);

    emit(LobbyState.success(
      state.gamesList,
      lobbyGameId,
      GameActionType.SHOW_PLAYER_GAME,
      state.playersList,
    ));
  }

  void closeGameSession() {
    emit(LobbyState.success(
      state.gamesList,
      null,
      null,
      state.playersList,
    ));
  }

  void changePlayerColor(LobbyGame lobbyGame) {
    lobbyRepository.changePlayerColor(lobbyGame);
  }

  void createNewGame() {
    lobbyRepository.createNewGame(
      NewGameConfig.fromCreateGameModel(CreateGameModel()),
    );
  }

  void saveChangedOptions(LobbyGame lobbyGame) {
    lobbyRepository.saveChangedOptions(lobbyGame);
  }

  @override
  Future<void> close() {
    lobbyRepository.unsubscribeOnNewGames();
    lobbyRepository.unsubscribeOnDeleteGame();
    lobbyRepository.unsubscribeOnPlayers();
    return super.close();
  }

  void setGameActionType(GameActionType? gameActionType, int? gameIdToAction) {
    emit(
      LobbyState.success(
        state.gamesList,
        gameIdToAction ?? state.gameIdToAction,
        gameActionType,
        state.playersList,
      ),
    );
  }
}
