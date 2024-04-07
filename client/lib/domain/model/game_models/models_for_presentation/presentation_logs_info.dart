import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/logs/LogMessage.dart';
import 'package:mars_flutter/domain/model/logs/LogMessageDataType.dart';

class PresentationLogsInfo extends Equatable {
  final Map<int, List<LogMessage>> logsByGenerations;
  final Map<PlayerColor, String> playersNames;

  const PresentationLogsInfo({
    required this.playersNames,
    required this.logsByGenerations,
  });

  @override
  List<Object?> get props => [
        logsByGenerations,
        playersNames,
      ];

  factory PresentationLogsInfo.clone(PresentationLogsInfo? logs) {
    if (logs == null) {
      return PresentationLogsInfo(playersNames: {}, logsByGenerations: {});
    } else {
      return PresentationLogsInfo(
          playersNames: Map<PlayerColor, String>.from(logs.playersNames),
          logsByGenerations: Map<int, List<LogMessage>>.from(
              logs.logsByGenerations.map((key, value) => MapEntry(
                    key,
                    List<LogMessage>.from(
                        value.map((e) => LogMessage.clone(e))),
                  ))));
    }
  }

  List<PlayerColor> get playedAwardsOrger {
    List<PlayerColor> result = [];
    for (final generationLog in logsByGenerations.values) {
      result = generationLog.fold(result, (acc, message) {
        PlayerColor? player = null;
        return message.data.fold(acc, (acc0, dataEntire) {
          if (dataEntire.type == LogMessageDataType.PLAYER) {
            player = PlayerColor.fromString(dataEntire.value);
          }
          return dataEntire.type == LogMessageDataType.AWARD && player != null
              ? [...acc0, player!]
              : acc0;
        });
      });
    }
    return result;
  }
}
