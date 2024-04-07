import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_logs_info.dart';

enum LogsStatus { loading, success, failure }

class LogsState extends Equatable {
  final LogsStatus status;
  final PresentationLogsInfo? logs;

  const LogsState._({
    this.status = LogsStatus.loading,
    this.logs = null,
  });

  const LogsState.loading() : this._();

  const LogsState.success(PresentationLogsInfo? logs)
      : this._(
          status: LogsStatus.success,
          logs: logs,
        );

  const LogsState.failure(PresentationLogsInfo? logs)
      : this._(
          status: LogsStatus.failure,
          logs: logs,
        );

  @override
  List<Object?> get props => [status, logs];
}
