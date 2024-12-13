import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/expanded_chat_panel/expanded_chat_panel.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/lobby_view/kit/lobby_notification_popup.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/lobby_view/lobby_view.dart';

//list of the games in right area, and chat in left area
class MainLobbyScreen extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  final double chatWidth;
  const MainLobbyScreen({
    super.key,
    required this.lobbyCubit,
    required this.gameChatCubit,
    required this.generalChatCubit,
    this.chatWidth = 300.0,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final chatPanelExpandedVN = ValueNotifier(false);
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Lobby'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 40.0,
            tooltip: 'Create new game',
            onPressed: () => //new game will be created and sent to the server
                //server will send back the game id
                //and the game settings will be shown instead of the LobbyView
                lobbyCubit.createNewGame(),
          )
        ],
      ),
      body: ExpandedChatPanel(
          expandedController: chatPanelExpandedVN,
          lobbyCubit: lobbyCubit,
          gameChatCubit: gameChatCubit,
          generalChatCubit: generalChatCubit,
          showGameMenu: false,
          child: BlocBuilder<LobbyCubit, LobbyState>(
              bloc: lobbyCubit,
              buildWhen: (pState, state) {
                final needGoToGame = lobbyCubit.needGoToGame;
                if (needGoToGame) {
                  context.go(localStorage.getItem(SELECTED_GAME_CLIENT) ??
                      GAME_CLIENT_ROUTE);
                }
                final gameToShowGameOptions =
                    state.gamesList?[state.gameIdToAction];
                if (gameToShowGameOptions != null && !needGoToGame) {
                  context.go(GAME_OPTIONS_ROUTE);
                }
                return !needGoToGame;
              },
              builder: (context, lobbyState) {
                if (lobbyState.notification != null)
                  showLobbyPopup(context, lobbyState.notification!, () {
                    lobbyCubit.clearNotification();
                  });
                logger.d('lobbyState changed: $lobbyState');

                return LobbyView(
                  lobbyCubit: lobbyCubit,
                  chatPanelSize: chatWidth,
                  chatPanelExpandedVN: chatPanelExpandedVN,
                );
              })),
    );
  }
}
