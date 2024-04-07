import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/common/socket.dart';
import 'package:mars_flutter/data/jwt.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/player.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LobbyAPIClient {
  final _socket = getNewSocketInstance('4001');
  String? _userId = null;
  String? get userId => _userId;
  final ValueNotifier<String?> jwt;
  final ValueNotifier<bool> isLobbyConnectionOk = ValueNotifier(false);
  void Function(Map<int, LobbyGame>)? _onNewGamesSubscriber = null;
  void Function(int)? _onDeleteGameSubscriber = null;
  void Function(Player)? _onPlayerSubscriber = null;
  subscribeOnNewGames(void Function(Map<int, LobbyGame>) onNewGames) =>
      _onNewGamesSubscriber = onNewGames;

  unsubscribeOnNewGames() => _onNewGamesSubscriber = null;

  subscribeOnDeleteGame(void Function(int) onDeleteGame) =>
      _onDeleteGameSubscriber = onDeleteGame;

  unsubscribeOnDeleteGame() => _onDeleteGameSubscriber = null;
  subscribeOnPlayers(void Function(Player) onPlayer) =>
      _onPlayerSubscriber = onPlayer;
  unsubscribeOnPlayers() => _onPlayerSubscriber = null;
  LobbyAPIClient(this.jwt) {
    _socket.onConnect((_) {
      logger.d('LobbyAPIClient connected');
      isLobbyConnectionOk.value = true;
    });

    _socket.onDisconnect((_) {
      logger.d('disconnected  from chat server');
      isLobbyConnectionOk.value = false;
    });

    _socket.onConnectError((err) {
      logger.d('LobbyAPIClient onConnectError error: $err');
      jwt.value = null;
      _socket.disconnect();
    });

    _socket.on('lobby_games', (newGamesFromServer) {
      logger.d('LobbyAPIClient lobby_games: $newGamesFromServer');

      if (_onNewGamesSubscriber != null) {
        Iterable l = jsonDecode(newGamesFromServer);
        final List<LobbyGame> games = l
            .map((e) => LobbyGame.fromJson(e as Map<String, dynamic>))
            .toList();

        final Map<int, LobbyGame> gamesMap = Map<int, LobbyGame>.fromIterable(
          games,
          key: (game) => game.lobbyGameId,
          value: (game) => game,
        );
        _onNewGamesSubscriber!(gamesMap);
      }
    });

    _socket.on('deleted_game', (lobbyGameId) {
      logger.d('LobbyAPIClient deleted_game: $lobbyGameId');

      if (_onDeleteGameSubscriber != null) {
        final id = int.parse(lobbyGameId);
        _onDeleteGameSubscriber!(id);
      }
    });

    _socket.on('player', (player) {
      logger.d('LobbyAPIClient player: $player');
      if (_onPlayerSubscriber != null) {
        final Map<String, dynamic> playerMap = jsonDecode(player);
        _onPlayerSubscriber!(Player.fromJson(playerMap));
      }
    });

    jwt.addListener(() => initConnectionToLobbyServer(jwt.value));
  }

  void dispose() {
    _socket.dispose();
    jwt.dispose();
    isLobbyConnectionOk.dispose();
  }

  void initConnectionToLobbyServer(String? jwt) {
    logger.d('LobbyAPIClient initConnectionToLobbyServer: $jwt');
    if (jwt != null && jwt != '') {
      _userId = getUserIdFromJwt(jwt);
      if (_socket.connected) _socket.disconnect();
      _socket.io.options['query'] = {'jwt': jwt};
      _socket.connect();
    } else {
      if (_socket.connected) _socket.disconnect();
    }
  }

  void startNewGame(int lobbyGameId) {
    logger.d("startNewGame: $lobbyGameId");
    _socket.emit('start_game', lobbyGameId.toString());
  }

  void publishNewGame(int lobbyGameId) {
    logger.d("publishNewGame: $lobbyGameId");
    _socket.emit('share_game', lobbyGameId.toString());
  }

  void joinNewGame(int lobbyGameId) {
    logger.d("joinNewGame: $lobbyGameId");
    _socket.emit('join_game', lobbyGameId.toString());
  }

  void leaveNewGame(int lobbyGameId) {
    logger.d("leaveNewGame: $lobbyGameId");
    _socket.emit('leave_game', lobbyGameId.toString());
  }

  void createNewGame(NewGameConfig newGameConfig) {
    logger.d("createNewGame");
    _socket.emit('create_new_game', jsonEncode(newGameConfig.toJson()));
  }

  void deleteGame(int lobbyGameId) {
    logger.d("deleteGame: $lobbyGameId");
    _socket.emit('delete_game', lobbyGameId.toString());
  }

  void loadPlayer(int lobbyGameId) {
    logger.d("loadPlayer: $lobbyGameId");
    _socket.emit('load_player', lobbyGameId.toString());
  }

  void saveChangedOptions(LobbyGame lobbyGame) {
    logger.d("saveChangedOptions : $lobbyGame ");
    _socket.emit(
      'save_changed_options',
      lobbyGame.toShortJson(),
    );
  }

  void changePlayerColor(LobbyGame lobbyGame) {
    logger.d("changePlayerColor : $lobbyGame ");
    _socket.emit(
      'change_player_color',
      lobbyGame.toShortJson(),
    );
  }

  void loadGames() {
    logger.d("loadGames");
    _socket.emit('load_games');
  }
}
