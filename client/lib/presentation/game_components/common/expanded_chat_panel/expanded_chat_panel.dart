import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/chat_state.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/common/chat_view/chat_view.dart';
import 'package:mars_flutter/presentation/game_components/common/game_menu_buttons_block.dart';
import 'package:mars_flutter/presentation/game_components/common/lobby_elements_tabs.dart';
import 'package:mars_flutter/presentation/game_components/common/expanded_chat_panel/kit/connection_indicator.dart';
import 'package:mars_flutter/presentation/game_components/common/expanded_chat_panel/kit/left_expanded_panel_view.dart';

class ExpandedChatPanel extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  final bool showGameMenu;
  final Widget child;
  final ValueNotifier<bool>? expandedController;
  final double width;
  const ExpandedChatPanel({
    super.key,
    required this.lobbyCubit,
    required this.gameChatCubit,
    required this.generalChatCubit,
    required this.child,
    this.showGameMenu = true,
    this.expandedController,
    this.width = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> expandedVN =
        expandedController == null ? ValueNotifier(false) : expandedController!;
    final ValueNotifier<int> newMessagesCountVN = ValueNotifier(0);

    final String? chatRoomKey = lobbyCubit.state.gameIdToAction?.toString();
    if (chatRoomKey != null) {
      gameChatCubit.chatRepository.subscribeOnEvents((eventsMap) {
        newMessagesCountVN.value =
            newMessagesCountVN.value + eventsMap.values.length;
      }, chatRoomKey, "IframeGameScreen");
    }
    const buttonWidth = 20.0;
    final goToLobbyButtonHeight = showGameMenu ? 30.0 : 0.0;
    const delay = Duration(milliseconds: 100);

    return Disposer(
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
            return ValueListenableBuilder(
                valueListenable: expandedVN,
                builder: (context, expanded, child) => LobbyElementsTabs(
                      width: width,
                      height: constraints.maxHeight - goToLobbyButtonHeight,
                      borderRadius: BorderRadius.zero,
                      children: expanded
                          ? [
                              if (gameChatState.chatKey != null)
                                ChatView(
                                  cubit: gameChatCubit,
                                ),
                              ChatView(
                                cubit: generalChatCubit,
                              ),
                            ]
                          : [SizedBox.expand()],
                      tabsNames: expanded
                          ? [
                              if (gameChatState.chatKey != null) "Game Chat",
                              "General Chat",
                            ]
                          : [""],
                    ));
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
                      expanded ? 0.0 : -(width - buttonWidth + 1) / width, 0),
                  duration: delay,
                  child: ValueListenableBuilder(
                    valueListenable: newMessagesCountVN,
                    builder: (context, newMessagesCount, child) {
                      return LeftExpandedPanelView(
                        width: width,
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
                        menuButtonsBlock: showGameMenu
                            ? GameMenuButtonsBlock(
                                width: width,
                                height: goToLobbyButtonHeight,
                                lobbyCubit: lobbyCubit,
                              )
                            : SizedBox.shrink(),
                      );
                    },
                  ),
                ),
                Row(children: [
                  AnimatedSize(
                    duration: delay,
                    child: Container(
                      width: expanded ? width + buttonWidth : buttonWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                  AnimatedSize(
                    duration: delay,
                    child: Container(
                      child: child,
                      width: expanded
                          ? constraints.maxWidth - width - buttonWidth
                          : constraints.maxWidth - buttonWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                ])
              ]);
            },
            child: child);
      }),
    );
  }
}
