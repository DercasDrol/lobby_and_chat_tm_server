import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/logs/LogMessageData.dart';
import 'package:mars_flutter/domain/model/logs/LogMessageType.dart';
import 'package:mars_flutter/domain/model/logs/Message.dart';

class LogMessage extends MessageWithData {
  final PlayerId? playerId;
  final int timestamp;
  final LogMessageType type;

  LogMessage({
    required this.playerId,
    required this.timestamp,
    required this.type,
    required final List<LogMessageData> data,
    required final String message,
  }) : super(data: data, message: message);

  factory LogMessage.fromJson(Map<String, dynamic> json) {
    return LogMessage(
      playerId: json['playerId'] == null
          ? null
          : PlayerId.fromString(json['playerId'] as String),
      timestamp: json['timestamp'] as int,
      type: LogMessageType.values[(json['type'] ?? 0) as int],
      data: (json['data'] as List)
          .map((e) => LogMessageData.fromJson(e))
          .toList(),
      message: json['message'] as String,
    );
  }

  @override
  List<Object?> get props => [playerId, timestamp, type, data, message];

  factory LogMessage.clone(LogMessage e) => LogMessage(
        playerId: PlayerId.fromString(e.playerId?.id),
        timestamp: e.timestamp,
        type: e.type,
        data: List.from(e.data.map((e0) => LogMessageData.clone(e0))),
        message: e.message,
      );
}
