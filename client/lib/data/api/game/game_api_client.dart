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

  static const String serverPath = "${GAME_SERVER_HOST}/";

  String _getPathWithId(RequestPath requestPath) =>
      serverPath + requestPath.toString() + "?id=";
  String get _playerPath => _getPathWithId(RequestPath.API_PLAYER);

  String get _spectatorPath => _getPathWithId(RequestPath.API_SPECTATOR);

  String get _playerInputPath => _getPathWithId(RequestPath.PLAYER_INPUT);

  String get _playerWaitingForPath =>
      _getPathWithId(RequestPath.API_WAITING_FOR);

  String get _gameLogsPath => _getPathWithId(RequestPath.API_GAME_LOGS);

  String get _gameInfoPath =>
      serverPath +
      RequestPath.API_GAME.toString() +
      "?id=" +
      (_gameId.id ?? "");

  Future<ViewModel> downloadAndParseGameStateJson(
    ParticipantId participantId,
  ) async {
    final path =
        participantId.runtimeType == PlayerId ? _playerPath : _spectatorPath;

    final response = await http.get(Uri.parse(path + (participantId.id ?? '')));
    if (response.statusCode == 200) {
      return ViewModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load json');
    }
  }

  //use for debug only
  Future<SimpleGameModel?> downloadAndParseAdminGameInfoJson() async {
    final response = await http.get(Uri.parse(this._gameInfoPath));
    if (response.statusCode == 200) {
      return SimpleGameModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
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
