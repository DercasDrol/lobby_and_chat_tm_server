import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/chat_state.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/repositories.dart';
import 'package:mars_flutter/presentation/core/common_future_widget.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/common/chat_view/chat_view.dart';
import 'package:mars_flutter/presentation/game_components/common/game_menu_buttons_block.dart';
import 'package:mars_flutter/presentation/game_components/common/lobby_elements_tabs.dart';
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
          final chatTabsView = BlocBuilder<ChatCubit, ChatState>(
            bloc: gameChatCubit,
            buildWhen: (previous, current) =>
                previous.chatKey != current.chatKey &&
                [previous.chatKey, current.chatKey].contains(null),
            builder: (context, gameChatState) {
              return LobbyElementsTabs(
                width: chatWidth,
                height: constraints.maxHeight - goToLobbyButtonHeight,
                borderRadius: BorderRadius.zero,
                children: [
                  if (gameChatState.chatKey != null)
                    ChatView(
                      cubit: gameChatCubit,
                    ),
                  ChatView(
                    cubit: generalChatCubit,
                  ),
                ],
                tabsNames: [
                  if (gameChatState.chatKey != null) "Game Chat",
                  "General Chat",
                ],
              );
            },
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
                        return LeftExpandedPanelForIframeGameClient(
                          width: chatWidth,
                          child: chatTabsView,
                          height: constraints.maxHeight,
                          goToLobbyButtonHeight: goToLobbyButtonHeight,
                          onExpandClick: () =>
                              expandedVN.value = !expandedVN.value,
                          buttonWidth: buttonWidth,
                          expanded: expanded,
                          counter: newMessagesCount,
                          connectionIndicator: ConnectionIndicator(
                            lobbyRepository: lobbyCubit.lobbyRepository,
                            chatRepository: gameChatCubit.chatRepository,
                          ),
                          menuButtonsBlock: GameMenuButtonsBlock(
                            width: chatWidth,
                            height: goToLobbyButtonHeight,
                            lobbyCubit: lobbyCubit,
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
              child: CommonFutureWidget<String>(
                future: Repositories.game.host,
                getContentView: (gameServer) {
                  final protocol = gameServer.startsWith("localhost")
                      ? "http://"
                      : "https://";
                  return IframeGameView(
                      participantId: participantId,
                      targetServerUrl: protocol + gameServer);
                },
              ));
        }),
      ),
    );
  }
}
