import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/chat_state.dart';
import 'package:mars_flutter/domain/logs_cubit.dart';
import 'package:mars_flutter/presentation/game_components/common/chat_view/chat_view.dart';
import 'package:mars_flutter/presentation/game_components/common/lobby_elements_tabs.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/left_expanded_panel/kit/logs_view.dart';

class ChatAndLogsTabsView extends StatelessWidget {
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  final LogsCubit logsCubit;
  final double width;
  final double height;
  final ScrollController scrollController;

  const ChatAndLogsTabsView({
    super.key,
    required this.gameChatCubit,
    required this.generalChatCubit,
    required this.width,
    required this.height,
    required this.logsCubit,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      bloc: gameChatCubit,
      buildWhen: (previous, current) =>
          previous.chatKey != current.chatKey &&
          [previous.chatKey, current.chatKey].contains(null),
      builder: (context, gameChatState) {
        return LobbyElementsTabs(
          width: width,
          height: height,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          children: [
            LogsView(
              logsCubit: logsCubit,
              scrollController: scrollController,
            ),
            if (gameChatState.chatKey != null)
              ChatView(
                cubit: gameChatCubit,
              ),
            ChatView(
              cubit: generalChatCubit,
            ),
          ],
          tabsNames: [
            "Game Logs",
            if (gameChatState.chatKey != null) "Game Chat",
            "General Chat",
          ],
        );
      },
    );
  }
}
