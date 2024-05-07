import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/chat_state.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/chat_event.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/user_info.dart';
import 'package:mars_flutter/presentation/game_components/common/chat_view/kit/event_list_view.dart';
import 'package:mars_flutter/presentation/game_components/common/chat_view/kit/message_input_view.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/lobby_elements_tabs.dart';

class ChatView extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  const ChatView({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
    required this.gameChatCubit,
    required this.generalChatCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = 10.0;
    const inputHeight = 60.0;
    const tabPadding = 5.0;
    const tabTitleHeight = 50.0;
    final createChatView = (ChatCubit cubit) => ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: width - 10,
            minHeight: height - tabTitleHeight,
            maxWidth: width,
            maxHeight: height - tabTitleHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<ChatCubit, ChatState>(
                bloc: cubit,
                buildWhen: (previous, current) =>
                    previous.onlineUsersIds.hashCode !=
                        current.onlineUsersIds.hashCode ||
                    previous.rebuldTrigger.hashCode !=
                        current.rebuldTrigger.hashCode,
                builder: (context, chatState) {
                  return Tooltip(
                      message: chatState.onlineUsersIds
                          .map((uId) =>
                              UserInfo.tryGetUserInfoById(uId)?.name ?? uId)
                          .toString(),
                      child: Text(
                        chatState.onlineUsersIds.length.toString() + " online",
                        style: TextStyle(color: Colors.white),
                      ));
                },
              ),
              GameOptionContainer(
                margin: EdgeInsets.all(tabPadding),
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: BlocBuilder<ChatCubit, ChatState>(
                  bloc: cubit,
                  builder: (context, chatState) {
                    final List<ChatEvent> events = (chatState.events ?? {})
                        .values
                        .toList()
                      ..sort(((a, b) => a.id.compareTo(b.id)));
                    return EventListView(
                      events: events,
                      width: width - padding * 2 - tabPadding * 2,
                      height:
                          height - padding * 4 - inputHeight - tabTitleHeight,
                      isCurrentUserSender: cubit.isCurrentUserSender,
                      isUserOnline: (String userId) =>
                          chatState.onlineUsersIds.contains(userId),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: MessageInputView(
                  onClickSend: cubit.sendMessage,
                  height: inputHeight,
                  width: width - padding - tabPadding,
                ),
              ),
            ],
          ),
        );

    return BlocBuilder<ChatCubit, ChatState>(
      bloc: gameChatCubit,
      buildWhen: (previous, current) =>
          previous.chatKey != current.chatKey &&
          [previous.chatKey, current.chatKey].contains(null),
      builder: (context, gameChatState) {
        return LobbyElementsTabs(
          width: width,
          height: height,
          borderRadius: borderRadius,
          children: [
            if (gameChatState.chatKey != null)
              createChatView(
                gameChatCubit,
              ),
            createChatView(generalChatCubit),
          ],
          tabsNames: [
            if (gameChatState.chatKey != null) "Game Chat",
            "General Chat",
          ],
          //controller: TabContainerController(
          //   initialIndex: 0, length: gameChatState.chatKey != null ? 2 : 1),
        );
      },
    );
  }
}
