import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/chat_event.dart';

enum ChatStatus { loading, success, connectionProblem }

class ChatState extends Equatable {
  final ChatStatus status;
  final String? chatKey;
  final Map<int /*ChatEvent.id*/, ChatEvent>? events;
  final Set<String> onlineUsersIds;
  //just to trigger rebuild when additional data (UserInfos) is loaded
  final bool rebuldTrigger;

  const ChatState._({
    this.status = ChatStatus.loading,
    this.events = null,
    this.onlineUsersIds = const <String>{},
    this.rebuldTrigger = false,
    this.chatKey = null,
  });

  const ChatState.loading(String? chatKey) : this._(chatKey: chatKey);

  const ChatState.success(Map<int, ChatEvent>? events,
      Set<String> onlineUsersIds, bool rebuldTrigger, String? chatKey)
      : this._(
          status: ChatStatus.success,
          events: events,
          onlineUsersIds: onlineUsersIds,
          rebuldTrigger: rebuldTrigger,
          chatKey: chatKey,
        );

  const ChatState.failure(Map<int, ChatEvent>? events,
      Set<String> onlineUsersIds, bool rebuldTrigger, String? chatKey)
      : this._(
          status: ChatStatus.connectionProblem,
          events: events,
          onlineUsersIds: onlineUsersIds,
          rebuldTrigger: rebuldTrigger,
          chatKey: chatKey,
        );

  @override
  List<Object?> get props => [
        status,
        events.hashCode,
        onlineUsersIds.hashCode,
        rebuldTrigger,
        chatKey
      ];
}
