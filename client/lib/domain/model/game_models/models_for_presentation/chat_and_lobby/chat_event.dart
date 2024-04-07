import 'package:equatable/equatable.dart';

enum ChatEventType {
  JOIN,
  LEAVE,
  MESSAGE;

  static ChatEventType fromString(String type) {
    switch (type) {
      case "join":
        return ChatEventType.JOIN;
      case "leave":
        return ChatEventType.LEAVE;
      case "message":
        return ChatEventType.MESSAGE;
      default:
        throw Exception("Unknown ChatEventType: $type");
    }
  }

  String toString() {
    switch (this) {
      case ChatEventType.JOIN:
        return "join";
      case ChatEventType.LEAVE:
        return "leave";
      case ChatEventType.MESSAGE:
        return "chat";
    }
  }

  String toChatString() {
    switch (this) {
      case ChatEventType.JOIN:
        return "joined";
      case ChatEventType.LEAVE:
        return "left";
      case ChatEventType.MESSAGE:
        return "sent a message";
    }
  }
}

class ChatEvent extends Equatable {
  final int id;
  final ChatEventType eventType;
  final String chatRoom;
  final String text;
  final String senderId;
  final DateTime timestamp;

  ChatEvent._({
    required this.id,
    required this.eventType,
    required this.chatRoom,
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  factory ChatEvent.fromJson(Map<String, dynamic> json) {
    return ChatEvent._(
      id: json['id'] as int,
      chatRoom: json['chatRoom'] as String,
      eventType: ChatEventType.fromString(json['evtType'] as String),
      text: json['text'] as String,
      senderId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  List<Object?> get props =>
      [id, eventType, chatRoom, text, senderId, timestamp];
}
