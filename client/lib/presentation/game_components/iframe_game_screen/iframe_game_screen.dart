import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/common/chat_view/chat_view.dart';
import 'package:mars_flutter/presentation/game_components/iframe_game_screen/kit/connection_indicator.dart';
import 'package:mars_flutter/presentation/game_components/iframe_game_screen/kit/left_expanded_panel_view.dart';
import 'package:mars_flutter/presentation/game_components/iframe_game_screen/kit/iframe_game_view.dart';

class IframeGameScreen extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  const IframeGameScreen({
    super.key,
    required this.lobbyCubit,
    required this.gameChatCubit,
    required this.generalChatCubit,
  });

  @override
  Widget build(BuildContext context) {
    final participantId = lobbyCubit.participantId;

    if (participantId == null) {
      lobbyCubit.closeGameSession();
      context.go(LOBBY_ROUTE);
      return const SizedBox.shrink();
    }
    ValueNotifier<bool> expandedVN = ValueNotifier(false);
    ValueNotifier<int> newMessagesCountVN = ValueNotifier(0);

    String? chatRoomKey = lobbyCubit.state.gameIdToAction?.toString();
    if (chatRoomKey != null) {
      gameChatCubit.chatRepository.subscribeOnEvents((eventsMap) {
        newMessagesCountVN.value =
            newMessagesCountVN.value + eventsMap.values.length;
      }, chatRoomKey, "IframeGameScreen");
    }
    const chatWidth = 300.0;
    const buttonWidth = 20.0;
    const goToLobbyButtonHeight = 30.0;
    const delay = Duration(milliseconds: 100);

    return Scaffold(
      body: Disposer(
        dispose: () {
          if (chatRoomKey != null)
            gameChatCubit.chatRepository
                .unsubscribeOnEvents(chatRoomKey, "IframeGameScreen");
          expandedVN.dispose();
        },
        child: LayoutBuilder(builder: (context, constraints) {
          final chatView = ChatView(
            gameChatCubit: gameChatCubit,
            generalChatCubit: generalChatCubit,
            width: chatWidth,
            height: constraints.maxHeight - goToLobbyButtonHeight,
            borderRadius: BorderRadius.zero,
          );
          return ValueListenableBuilder(
            valueListenable: expandedVN,
            builder: (context, expanded, child) {
              if (expanded) {
                newMessagesCountVN.value = 0;
              }
              return Stack(children: [
                AnimatedSlide(
                  offset: Offset(
                      expanded
                          ? 0.0
                          : -(chatWidth - buttonWidth + 1) / chatWidth,
                      0),
                  duration: delay,
                  child: ValueListenableBuilder(
                    valueListenable: newMessagesCountVN,
                    builder: (context, newMessagesCount, child) {
                      return LeftExpandedPanelView(
                        width: chatWidth,
                        child: chatView,
                        height: constraints.maxHeight,
                        goToLobbyButtonHeight: goToLobbyButtonHeight,
                        onExpandClick: () =>
                            expandedVN.value = !expandedVN.value,
                        onGoToLobbyClick: () {
                          lobbyCubit.closeGameSession();
                        },
                        buttonWidth: buttonWidth,
                        expanded: expanded,
                        counter: newMessagesCount,
                        connectionIndicator: ConnectionIndicator(
                          lobbyRepository: lobbyCubit.lobbyRepository,
                          chatRepository: gameChatCubit.chatRepository,
                        ),
                      );
                    },
                  ),
                ),
                Row(children: [
                  AnimatedSize(
                    duration: delay,
                    child: Container(
                      width: expanded ? chatWidth + buttonWidth : buttonWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                  AnimatedSize(
                    duration: delay,
                    child: Container(
                      child: child,
                      width: expanded
                          ? constraints.maxWidth - chatWidth - buttonWidth
                          : constraints.maxWidth - buttonWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                ])
              ]);
            },
            child: IframeGameView(participantId: participantId),
          );
        }),
      ),
    );
  }
}
