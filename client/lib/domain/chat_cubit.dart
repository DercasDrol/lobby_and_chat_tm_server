import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mars_flutter/data/api/chat/chat_api_client.dart';
import 'package:mars_flutter/domain/chat_state.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/chat_event.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/user_info.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatAPIClient chatRepository;

  ChatCubit(this.chatRepository, String? chatKey)
      : super(ChatState.loading(chatKey));
  String? get userId => chatRepository.userId;

  void init() {
    if (state.chatKey != null) {
      initChatRoom(state.chatKey!);
    }
  }

  void initChatRoom(String chatKey) {
    chatRepository.subscribeOnEvents(
        (Map<int /*ChatEvent.id*/, ChatEvent> eventsFromServer) {
      final Set<String> toGetUserInfosSet = {};
      eventsFromServer.forEach(
        (_, value) {
          if ((UserInfo.tryGetUserInfoById(value.senderId) == null)) {
            toGetUserInfosSet.add(value.senderId);
          }
        },
      );
      if (toGetUserInfosSet.isNotEmpty) {
        chatRepository.askUserInfos(toGetUserInfosSet);
      }
      eventsFromServer.addAll(state.events ?? {});
      emit(ChatState.success(eventsFromServer, state.onlineUsersIds,
          state.rebuldTrigger, state.chatKey));
    }, chatKey, "ChatCubit.init");

    chatRepository.subscribeOnOnlineUsersListChanges(
      (Set<String /*UserId*/ > usersIds) {
        final Set<String> toGetUserInfosSet = {};
        usersIds.forEach(
          (uId) {
            if ((UserInfo.tryGetUserInfoById(uId) == null)) {
              toGetUserInfosSet.add(uId);
            }
          },
        );
        if (toGetUserInfosSet.isNotEmpty) {
          chatRepository.askUserInfos(toGetUserInfosSet);
        }
        emit(ChatState.success(
            state.events, usersIds, state.rebuldTrigger, state.chatKey));
      },
      chatKey,
    );

    chatRepository.subscribeOnUsersInfos(
      () {
        emit(
          ChatState.success(state.events, state.onlineUsersIds,
              !state.rebuldTrigger, state.chatKey),
        );
      },
      chatKey,
    );

    chatRepository.isChatConnectionOk.addListener(() {
      if (!chatRepository.isChatConnectionOk.value) {
        emit(ChatState.failure(state.events, state.onlineUsersIds,
            state.rebuldTrigger, state.chatKey));
      }
    });

    chatRepository.joinToChatRoom(chatKey);
    chatRepository.subscribeRoomOnReconnect(chatKey);
  }

  set chatKey(String? chatKey) {
    if (chatKey != state.chatKey) {
      dispose();
      emit(
        ChatState.success(
          state.events,
          state.onlineUsersIds,
          state.rebuldTrigger,
          chatKey,
        ),
      );
      init();
    }
  }

  void sendMessage(String message) {
    if (state.chatKey != null)
      chatRepository.sendMessage(message, state.chatKey!);
  }

  bool isCurrentUserSender(ChatEvent message) {
    return this.userId == message.senderId;
  }

  void dispose() {
    if (state.chatKey == null) return;
    chatRepository.unsubscribeOnEvents(state.chatKey!, "ChatCubit.init");
    chatRepository.unsubscribeRoomOnReconnect(state.chatKey!);
    chatRepository.unsubscribeOnOnlineUsersListChanges(state.chatKey!);
    chatRepository.unsubscribeOnUsersInfos(state.chatKey!);
    chatRepository.leaveChatRoom(state.chatKey!);
    emit(ChatState.loading(null));
  }

  @override
  Future<void> close() {
    print("ChatCubit ${state.chatKey} closed");
    dispose();
    return super.close();
  }
}
