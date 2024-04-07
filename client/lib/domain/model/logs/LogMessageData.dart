import 'LogMessageDataType.dart';

class LogMessageData {
  final LogMessageDataType type;
  final String value;
  LogMessageData({required this.type, required this.value});

  factory LogMessageData.fromJson(Map<String, dynamic> json) {
    return LogMessageData(
      type: LogMessageDataType.values[json['type'] as int],
      value: json['value'] as String,
    );
  }

  factory LogMessageData.clone(LogMessageData e0) {
    return LogMessageData(type: e0.type, value: e0.value);
  }
}
