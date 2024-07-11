import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/app/RequestPaths.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/SimpleGameModel.dart';
import 'package:mars_flutter/domain/model/game_models/WaitingForModel.dart';
import 'package:mars_flutter/domain/model/inputs/InputResponse.dart';
import 'package:mars_flutter/domain/model/logs/LogMessage.dart';

class GameAPIClient {
  final Future<String> host;
  GameAPIClient({required this.host});
  GameId _gameId = GameId.fromString("g6491874bdbcc"); //use for debug only

  Future<String> _getPathWithId(RequestPath requestPath) async {
    final host = await this.host;
    final _protocol = host.startsWith("localhost:") ? "http://" : "https://";
    return _protocol + host + '/' + requestPath.toString() + "?id=";
  }

  Future<ViewModel> downloadAndParseGameStateJson(
    ParticipantId participantId,
  ) async {
    final path = participantId.runtimeType == PlayerId
        ? await _getPathWithId(RequestPath.API_PLAYER)
        : await _getPathWithId(RequestPath.API_SPECTATOR);

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
    final _gameInfoPath = await _getPathWithId(RequestPath.API_GAME);
    final response =
        await http.get(Uri.parse(_gameInfoPath + (_gameId.id ?? "")));
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
    final _playerInputPath = await _getPathWithId(RequestPath.PLAYER_INPUT);
    final response = await http.post(
        Uri.parse(
          _playerInputPath + (participantId.id ?? ''),
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
      final _playerWaitingForPath =
          await _getPathWithId(RequestPath.API_WAITING_FOR);
      final Response response = await http.get(
        Uri.parse(
          _playerWaitingForPath +
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
      final _gameLogsPath = await _getPathWithId(RequestPath.API_GAME_LOGS);
      final Response response = await http.get(
        Uri.parse(
          _gameLogsPath +
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
