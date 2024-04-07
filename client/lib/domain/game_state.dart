import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/SimpleGameModel.dart';

enum ViewModelStatus { loading, success, failure }

class GameState extends Equatable {
  final ViewModelStatus status;
  final String? error;
  final ViewModel? viewModel;
  final SimpleGameModel? gameInfo;
  final ParticipantId? participantId;

  const GameState._({
    this.status = ViewModelStatus.loading,
    this.viewModel = null,
    this.error = null,
    this.gameInfo = null,
    this.participantId = null,
  });

  const GameState.loading() : this._();

  const GameState.success(
    ViewModel? viewModel,
    SimpleGameModel? gameInfo,
    ParticipantId? participantId,
  ) : this._(
          status: ViewModelStatus.success,
          viewModel: viewModel,
          gameInfo: gameInfo,
          participantId: participantId,
        );

  const GameState.failure(
    ViewModel? viewModel,
    SimpleGameModel? gameInfo,
    ParticipantId? participantId,
  ) : this._(
          status: ViewModelStatus.failure,
          viewModel: viewModel,
          gameInfo: gameInfo,
          participantId: participantId,
        );

  @override
  List<Object?> get props =>
      [status, viewModel, error, gameInfo, participantId];
}
