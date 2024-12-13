import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_category.dart';
import 'package:mars_flutter/presentation/game_components/common/lobby_elements_tabs.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/lobby_view/kit/games_list/games_list.dart';

class LobbyView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final double chatPanelSize;
  final ValueNotifier<bool> chatPanelExpandedVN;

  const LobbyView({
    super.key,
    required this.lobbyCubit,
    required this.chatPanelSize,
    required this.chatPanelExpandedVN,
  });

  @override
  Widget build(BuildContext context) {
    final minLobbyWidth = 320.0;
    return ValueListenableBuilder(
      valueListenable: chatPanelExpandedVN,
      builder: (context, chatPanelExpanded, child) => LayoutBuilder(
        builder: (context, constrains) {
          final height = constrains.maxHeight;
          final width = chatPanelExpanded &&
                  constrains.maxWidth < minLobbyWidth + chatPanelSize
              ? constrains.maxWidth + chatPanelSize
              : constrains.maxWidth;
          final buildGameList = (lobbyCategory, width0) => GamesList(
                lobbyCubit: lobbyCubit,
                height: height,
                lobbyCategory: lobbyCategory,
                width: width0,
              );
          final devidedWidth = width / 3 - 10;
          return width / (minLobbyWidth * 1.2) > 3
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                  ),
                  child: Row(
                    spacing: 10.0,
                    children: [
                      LobbyElementsTabs(
                        width: devidedWidth,
                        height: height,
                        children: [
                          buildGameList(
                              LobbyCategory.GAMES_TO_JOIN, devidedWidth)
                        ],
                        tabsNames: ["Look for Games"],
                      ),
                      LobbyElementsTabs(
                        width: devidedWidth,
                        height: height,
                        children: [
                          buildGameList(LobbyCategory.OWN_GAMES, devidedWidth)
                        ],
                        tabsNames: ["Your Games"],
                      ),
                      LobbyElementsTabs(
                        width: devidedWidth,
                        height: height,
                        children: [
                          buildGameList(
                              LobbyCategory.GAMES_TO_WATCH, devidedWidth)
                        ],
                        tabsNames: ["Games to Watch"],
                      )
                    ],
                  ),
                )
              : LobbyElementsTabs(
                  width: width,
                  height: height,
                  children: [
                    buildGameList(LobbyCategory.GAMES_TO_JOIN, width),
                    buildGameList(LobbyCategory.OWN_GAMES, width),
                    buildGameList(LobbyCategory.GAMES_TO_WATCH, width),
                  ],
                  tabsNames: ["Look for Games", "Your Games", "Games to Watch"],
                  //controller: controller,
                );
        },
      ),
    );
  }
}
