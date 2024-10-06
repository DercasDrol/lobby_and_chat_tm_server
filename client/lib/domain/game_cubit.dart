// ignore_for_file: sdk_version_since

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/game/game_api_client.dart';
import 'package:mars_flutter/domain/game_state.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/WaitingForModel.dart';
import 'package:mars_flutter/domain/model/inputs/InputResponse.dart';

class GameCubit extends Cubit<GameState> {
  final GameAPIClient repository;
  final void Function(
    List<PublicPlayerModel>? players,
    int generation,
    ParticipantId participantId,
  ) additionalOnChangeFn;
  GameCubit({
    required this.repository,
    required this.additionalOnChangeFn,
  }) : super(const GameState.loading());

  Future<void> fetch() async {
    logger.d("debug: fetch()");
    try {
      //final SimpleGameModel? gameModel =
      //    await repository.downloadAndParseAdminGameInfoJson();
      emit(GameState.success(
          this.state.viewModel, null, this.state.participantId));
      if (this.state.participantId != null) {
        final ViewModel viewModel = await repository
            .downloadAndParseGameStateJson(this.state.participantId!);

        if (!viewModel.isContainsWaitingFor)
          _sendWaitingFor(viewModel.game.gameAge, viewModel.game.undoCount,
              this.state.participantId);
        emit(GameState.success(
            viewModel, this.state.gameInfo, this.state.participantId));
      }
    } on Exception {
      emit(GameState.failure(
          this.state.viewModel, this.state.gameInfo, this.state.participantId));
    }
  }

  void setParticipant(ParticipantId? participantId) {
    logger.d("debug: setParticipant(ParticipantId)");
    emit(GameState.success(
        this.state.viewModel, this.state.gameInfo, participantId));
    fetch();
  }

  void tryChangeActiveParticipant(PlayerColor playerColor) {
    logger.d("debug: TryChangeActivePlayer");
    try {
      final participantId = this.state.gameInfo == null
          ? null
          : this
              .state
              .gameInfo!
              .players
              .firstWhere((element) => element.color == playerColor)
              .id;
      emit(GameState.success(
          this.state.viewModel, this.state.gameInfo, participantId));
    } on Exception {
      emit(GameState.failure(
          this.state.viewModel, this.state.gameInfo, this.state.participantId));
    }
    fetch();
  }

  Future<void> _sendWaitingFor(
    int gameAge,
    int undoCount,
    participantId,
  ) async {
    logger.d("this.state.participantId");
    logger.d(this.state.participantId);
    if (participantId != this.state.participantId ||
        this.state.participantId?.id == null) return;
    try {
      final WaitingForModelResult? waitingForModelResult =
          await repository.sendWaitingFor(gameAge, undoCount, participantId);
      var sendAgain = () => Timer(Duration(seconds: 2),
          () => _sendWaitingFor(gameAge, undoCount, participantId));
      switch (waitingForModelResult) {
        case WaitingForModelResult.WAIT:
          sendAgain();
          break;
        case WaitingForModelResult.REFRESH:
          fetch();
          break;
        case WaitingForModelResult.GO:
          fetch();
          break;
        case null:
          emit(GameState.failure(this.state.viewModel, this.state.gameInfo,
              this.state.participantId));
          sendAgain();
          break;
        default:
          emit(GameState.failure(this.state.viewModel, this.state.gameInfo,
              this.state.participantId));
      }
    } on Exception {
      emit(GameState.failure(
          this.state.viewModel, this.state.gameInfo, this.state.participantId));
    }
  }

  Future<void> sendPlayerAction(InputResponse inputResponse) async {
    try {
      if (this.state.participantId == null) return;
      final viewModel =
          await repository.sendActionAndDownloadAndParseGameStateJson(
        inputResponse,
        this.state.participantId!,
        state.viewModel,
      );
      if (viewModel != null && !viewModel.isContainsWaitingFor)
        _sendWaitingFor(
          viewModel.game.gameAge,
          viewModel.game.undoCount,
          this.state.participantId,
        );
      emit(GameState.success(
        viewModel,
        this.state.gameInfo,
        this.state.participantId,
      ));
    } on Exception {
      emit(GameState.failure(
        this.state.viewModel,
        this.state.gameInfo,
        this.state.participantId,
      ));
    }
  }

  @override
  void emit(GameState state) {
    super.emit(state);
    Future.delayed(Duration(seconds: 1), () {
      var players = this.state.viewModel?.players;
      var participantId = this.state.participantId ?? this.state.viewModel?.id;
      var generation = this.state.viewModel?.game.generation;
      if (players != null && participantId != null && generation != null) {
        this.additionalOnChangeFn(players, generation, participantId);
      }
    });
  }
}
