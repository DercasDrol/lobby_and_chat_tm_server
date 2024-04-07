import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/logs/LogMessageDataType.dart';

import 'LogMessageData.dart';

class Message extends Equatable {
  final String message;
  Message({required this.message});
  factory Message.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      return MessageWithData(
        data: (json['data'] as List)
            .map((e) => LogMessageData.fromJson(e))
            .toList(),
        message: json['message'] as String,
      );
    } else {
      return Message(message: json['message'] as String);
    }
  }
  @override
  String toString() {
    return message;
  }

  @override
  List<Object?> get props => [message];
}

class MessageWithData extends Message {
  final List<LogMessageData> data;
  MessageWithData({required this.data, required final String message})
      : super(message: message);
  @override
  String toString() {
    var dataString = data.map(
      (e) {
        switch (e.type) {
          case LogMessageDataType.RAW_STRING:
            return e.value;
          default:
            return e.value;
        }
      },
    ).toList();
    String message = this.message;
    for (var i = 0; i < dataString.length; i++) {
      message = message.replaceFirst("\${${i}}", dataString[i]);
    }
    return message;
  }

  @override
  List<Object?> get props => [data, message];
}
