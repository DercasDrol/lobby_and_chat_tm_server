// ignore_for_file: sdk_version_since

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/game/game_api_client.dart';
import 'package:mars_flutter/domain/logs_state.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_logs_info.dart';

import 'package:mars_flutter/domain/model/logs/LogMessage.dart';
import 'package:mars_flutter/domain/model/logs/LogMessageType.dart';

class LogsCubit extends Cubit<LogsState> {
  final GameAPIClient repository;

  LogsCubit({required this.repository}) : super(const LogsState.loading());

  Future<void> getGameLogs(
    List<PublicPlayerModel>? players,
    int generation,
    ParticipantId participantId,
  ) async {
    try {
      PresentationLogsInfo gameLogs =
          PresentationLogsInfo.clone(this.state.logs);
      gameLogs.playersNames.addAll(
        Map.fromIterable(
          players ?? [],
          key: (e) => (e as PublicPlayerModel).color,
          value: (e) => (e as PublicPlayerModel).name,
        ),
      );
      for (int i = 1; i < generation; i++) {
        if (!gameLogs.logsByGenerations.containsKey(i)) {
          List<LogMessage> messages =
              await repository.getGameLogs(i, participantId);
          messages.removeWhere(
              (element) => element.type == LogMessageType.NEW_GENERATION);
          gameLogs.logsByGenerations[i] = messages;
        }
      }
      List<LogMessage> messages =
          await repository.getGameLogs(generation, participantId);
      int generationIndx = messages.lastIndexWhere(
          (element) => element.type == LogMessageType.NEW_GENERATION);
      logger.d("Debug: old ${gameLogs.logsByGenerations[generation]}");
      gameLogs.logsByGenerations[generation] = generationIndx == -1
          ? messages
          : generationIndx == messages.length - 1
              ? []
              : messages.getRange(generationIndx + 1, messages.length).toList();
      logger.d("Debug: new ${gameLogs.logsByGenerations[generation]}");
      emit(LogsState.success(gameLogs));
    } on Exception {
      emit(LogsState.failure(this.state.logs));
    }
  }
}
