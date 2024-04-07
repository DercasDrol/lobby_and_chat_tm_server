import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/constants.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/app/RequestPaths.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/SimpleGameModel.dart';
import 'package:mars_flutter/domain/model/game_models/WaitingForModel.dart';
import 'package:mars_flutter/domain/model/inputs/InputResponse.dart';
import 'package:mars_flutter/domain/model/logs/LogMessage.dart';

class GameAPIClient {
  GameId _gameId = GameId.fromString("g6491874bdbcc"); //use for debug only
  // static const String _lobbyServerPath = "http://localhost:3000/";
  static const String _serverPath =
      "${GAME_SERVER_PROTOCOL}://${GAME_SERVER_HOST}/";
  String getPath(RequestPath requestPath) =>
      _serverPath + requestPath.toString() + "?id=";
  String get _playerPath => getPath(RequestPath.API_PLAYER);

  String get _spectatorPath => getPath(RequestPath.API_SPECTATOR);

  String get _playerInputPath => getPath(RequestPath.PLAYER_INPUT);

  String get _playerWaitingForPath => getPath(RequestPath.API_WAITING_FOR);

  String get _gameLogsPath => getPath(RequestPath.API_GAME_LOGS);

  String get _gameInfoPath =>
      _serverPath +
      RequestPath.API_GAME.toString() +
      "?id=" +
      (_gameId.id ?? "");
  static const _headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
  };

  Future<ViewModel> downloadAndParseGameStateJson(
    ParticipantId participantId,
  ) async {
    final path =
        participantId.runtimeType == PlayerId ? _playerPath : _spectatorPath;

    final response = await http.get(Uri.parse(path + (participantId.id ?? '')),
        headers: _headers);
    if (response.statusCode == 200) {
      return ViewModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load json');
    }
  }

  //use for debug only
  Future<SimpleGameModel> downloadAndParseAdminGameInfoJson() async {
    final response = await http.get(
      Uri.parse(this._gameInfoPath),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return SimpleGameModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load json');
    }
  }

  Future<ViewModel> sendActionAndDownloadAndParseGameStateJson(
    InputResponse inputResponse,
    ParticipantId participantId,
  ) async {
    logger.d("debug: sendActionAndDownloadAndParseGameStateJson");
    logger.d(inputResponse);
    logger.d(jsonEncode(inputResponse.toJson()));
    final response = await http.post(
        Uri.parse(
          this._playerInputPath + (participantId.id ?? ''),
        ),
        headers: _headers,
        body: jsonEncode(inputResponse.toJson()));
    if (response.statusCode == 200) {
      return ViewModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load json');
    }
  }

  Future<WaitingForModelResult?> sendWaitingFor(
    int gameAge,
    int undoCount,
    ParticipantId participantId,
  ) async {
    logger.d("debug: sendWaitingFor");
    try {
      final Response response = await http.get(
        Uri.parse(
          this._playerWaitingForPath +
              (participantId.id ?? "") +
              "&gameAge=" +
              gameAge.toString() +
              "&undoCount=" +
              undoCount.toString(),
        ),
        headers: _headers,
      );

      logger.d("debug: ${response.statusCode}");
      if (response.statusCode == 200) {
        logger.d("debug: ${response.body}");
        return WaitingForModelResult.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes))
                as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load json');
      }
    } on Exception {
      logger.d("debug: request error");
      throw Exception('Failed to load json');
    }
  }

  Future<List<LogMessage>> getGameLogs(
    int generation,
    ParticipantId participantId,
  ) async {
    logger.d("debug: getGameLogs");
    try {
      final Response response = await http.get(
        Uri.parse(
          this._gameLogsPath +
              (participantId.id ?? "") +
              "&generation=" +
              generation.toString(),
        ),
        headers: _headers,
      );

      logger.d("debug: ${response.statusCode}");
      if (response.statusCode == 200) {
        logger.d("debug: ${response.body}");
        return (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>)
            .map((e) => LogMessage.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load json');
      }
    } on Exception {
      logger.d("debug: request error");
      throw Exception('Failed to load json');
    }
  }
}
