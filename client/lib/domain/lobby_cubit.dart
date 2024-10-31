// ignore_for_file: sdk_version_since

import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/lobby/lobby_api_client.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game_template.dart';
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

  bool get isTemplateChanged =>
      state.selectedTemplateId != null &&
      state.gameTemplatesList?[state.selectedTemplateId]?.createGameModel !=
          state.gamesList?[state.gameIdToAction]?.createGameModel
              .copyWith(players: []);
  PlayerId? get playerId => state.playersList?[state.gameIdToAction]?.playerId;
  ParticipantId? get participantId {
    final targetGame = state.gamesList?[state.gameIdToAction];
    return playerId != null && state.gameActionType?.isGoToGame != null
        ? playerId
        : state.gameActionType?.isGoToGame != null
            ? targetGame?.spectatorId
            : null;
  }

  bool get currentGameStarted =>
      state.gamesList?[state.gameIdToAction]?.startedAt != null;

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
            state.gameTemplatesList,
            newGameIdToShowInLobby,
            state.selectedTemplateId,
            gameActionType,
            state.playersList,
            state.notification,
          ),
        );
      },
    );

    lobbyRepository.subscribeOnDeleteGame((lobbyGameId) {
      final newGamesList = new Map<int, LobbyGame>.from(state.gamesList ?? {});
      newGamesList.remove(lobbyGameId);
      final gameIdToShowGameOptions =
          lobbyGameId == state.gameIdToAction ? null : state.gameIdToAction;
      final isCurrentUserOwner =
          state.gamesList?[lobbyGameId]?.userIdCreatedBy == userId;
      final doesGameExist = state.gamesList?[lobbyGameId] != null;
      final isUserJoined = state
              .gamesList?[lobbyGameId]?.createGameModel.players
              .any((NewPlayerModel player) => player.userId == userId) ??
          false;
      emit(LobbyState.success(
        newGamesList,
        state.gameTemplatesList,
        gameIdToShowGameOptions,
        state.selectedTemplateId,
        state.gameActionType,
        state.playersList,
        doesGameExist && !isCurrentUserOwner && isUserJoined
            ? 'The game was cancelled by owner'
            : state.notification,
      ));
    });

    lobbyRepository.subscribeOnNewGameTemplates(
        (Map<int, LobbyGameTemplate> newTemplatesFromServer) {
      final newTemplatesList =
          new Map<int, LobbyGameTemplate>.from(state.gameTemplatesList ?? {});
      newTemplatesList.addAll(newTemplatesFromServer);
      emit(LobbyState.success(
        state.gamesList,
        newTemplatesList,
        state.gameIdToAction,
        state.selectedTemplateId,
        state.gameActionType,
        state.playersList,
        state.notification,
      ));
    });

    lobbyRepository.subscribeOnDeleteGameTemplate((templateId) {
      final newTemplatesList =
          new Map<int, LobbyGameTemplate>.from(state.gameTemplatesList ?? {});
      newTemplatesList.remove(templateId);
      final selectedTemplateId = state.selectedTemplateId == templateId
          ? null
          : state.selectedTemplateId;
      emit(LobbyState.success(
        state.gamesList,
        newTemplatesList,
        state.gameIdToAction,
        selectedTemplateId,
        state.gameActionType,
        state.playersList,
        state.notification,
      ));
    });

    lobbyRepository.subscribeOnPlayers((Player player) {
      final newPlayersList = new Map<int, Player>.from(state.playersList ?? {});
      newPlayersList[player.lobbyGameId] = player;
      emit(LobbyState.success(
        state.gamesList,
        state.gameTemplatesList,
        state.gameIdToAction,
        state.selectedTemplateId,
        state.gameActionType,
        newPlayersList,
        state.notification,
      ));
    });

    lobbyRepository.isLobbyConnectionOk.addListener(() {
      if (!lobbyRepository.isLobbyConnectionOk.value) {
        emit(LobbyState.failure(
          state.gamesList,
          state.gameTemplatesList,
          state.gameIdToAction,
          state.selectedTemplateId,
          state.gameActionType,
          state.playersList,
          state.notification,
        ));
      } else {
        final templateId = int.tryParse(
            localStorage.getItem('selectedTemplateId.$userId') ?? '');
        emit(LobbyState.success(
          state.gamesList,
          state.gameTemplatesList,
          state.gameIdToAction,
          templateId,
          state.gameActionType,
          state.playersList,
          state.notification,
        ));
      }
    });
    lobbyRepository.loadGames();
    lobbyRepository.loadGameTemplates();
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
      state.gameTemplatesList,
      null,
      state.selectedTemplateId,
      state.gameActionType,
      state.playersList,
      state.notification,
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
      state.gameTemplatesList,
      lobbyGameId,
      state.selectedTemplateId,
      GameActionType.SHOW_PLAYER_GAME,
      state.playersList,
      state.notification,
    ));
  }

  void closeGameSession() {
    emit(LobbyState.success(
      state.gamesList,
      state.gameTemplatesList,
      null,
      state.selectedTemplateId,
      null,
      state.playersList,
      state.notification,
    ));
  }

  void changePlayerColor(LobbyGame lobbyGame) {
    lobbyRepository.changePlayerColor(lobbyGame);
  }

  void createNewGame() {
    final gameModelFromTemplate =
        state.gameTemplatesList?[state.selectedTemplateId]?.createGameModel;
    lobbyRepository.createNewGame(
      NewGameConfig.fromCreateGameModel(
          gameModelFromTemplate ?? CreateGameModel()),
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
    lobbyRepository.unsubscribeOnNewGameTemplates();
    lobbyRepository.unsubscribeOnDeleteGameTemplate();
    return super.close();
  }

  void setGameActionType(GameActionType? gameActionType, int? gameIdToAction) {
    emit(
      LobbyState.success(
        state.gamesList,
        state.gameTemplatesList,
        gameIdToAction ?? state.gameIdToAction,
        state.selectedTemplateId,
        gameActionType,
        state.playersList,
        state.notification,
      ),
    );
  }

  void setGameTemplate(int? templateId) {
    if (templateId == state.selectedTemplateId) return;
    localStorage.setItem('selectedTemplateId.$userId', templateId.toString());
    final template = state.gameTemplatesList?[templateId];
    final gameTobeChanged = state.gamesList?[state.gameIdToAction];
    final changedGame = gameTobeChanged?.copyWith(
      createGameModel:
          (template?.createGameModel ?? CreateGameModel()).copyWith(
        maxPlayers: max(
          gameTobeChanged.createGameModel.players.length,
          gameTobeChanged.createGameModel.maxPlayers,
        ),
        players: gameTobeChanged.createGameModel.players,
      ),
    );
    if (changedGame != null) saveChangedOptions(changedGame);
    emit(
      LobbyState.success(
        state.gamesList,
        state.gameTemplatesList,
        state.gameIdToAction,
        templateId,
        state.gameActionType,
        state.playersList,
        state.notification,
      ),
    );
  }

  void saveTemplateChanges() {
    final templateId = state.selectedTemplateId;
    final template = state.gameTemplatesList?[templateId];
    final gameId = state.gameIdToAction;
    if (template != null && gameId != null) {
      final newTemplate = template.copyWith(
        createGameModel:
            state.gamesList?[gameId]?.createGameModel.copyWith(players: []) ??
                template.createGameModel,
      );
      lobbyRepository.updateGameTemplate(newTemplate);
    }
  }

  void createNewTemplate(String name) {
    final gameId = state.gameIdToAction;
    if (gameId != null) {
      final game = state.gamesList?[gameId];
      if (game != null) {
        final newTemplate = LobbyGameTemplate(
          id: -1,
          name: name,
          createGameModel: game.createGameModel.copyWith(players: []),
        );
        lobbyRepository.saveGameTemplate(newTemplate);
      }
    }
  }

  void removeTemplate(int templateId) {
    lobbyRepository.deleteGameTemplate(templateId);
  }

  void clearNotification() {
    emit(
      LobbyState.success(
        state.gamesList,
        state.gameTemplatesList,
        state.gameIdToAction,
        state.selectedTemplateId,
        state.gameActionType,
        state.playersList,
        null,
      ),
    );
  }
}
