import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/expanded_chat_panel/expanded_chat_panel.dart';

import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/game_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/lobby_view/kit/lobby_notification_popup.dart';

//list of the games in left area, and chat in right area
class GameOptionsScreen extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  final double chatWidth;
  const GameOptionsScreen({
    super.key,
    required this.lobbyCubit,
    required this.gameChatCubit,
    required this.generalChatCubit,
    this.chatWidth = 300.0,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final userId = lobbyCubit.userId;
    final chatPanelExpandedVN = ValueNotifier(false);
    final startButton = BlocBuilder<LobbyCubit, LobbyState>(
        bloc: lobbyCubit,
        buildWhen: (pState, state) {
          final oldGameToShowGameOptions =
              pState.gamesList?[pState.gameIdToAction];
          final gameToShowGameOptions = state.gamesList?[state.gameIdToAction];
          return oldGameToShowGameOptions != gameToShowGameOptions;
        },
        builder: (context, lobbyState) {
          final lobbyGame = lobbyState.gamesList?[lobbyState.gameIdToAction];
          if (lobbyGame == null || userId != lobbyGame.userIdCreatedBy) {
            return SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: BottomButton(
              text: lobbyGame.createGameModel.maxPlayers !=
                      lobbyGame.createGameModel.playersCount
                  ? lobbyGame.createGameModel.playersCount == 1
                      ? 'Start solo game'
                      : 'Start game with ${lobbyGame.createGameModel.playersCount.toString()} players'
                  : 'Start game',
              onPressed: () => lobbyCubit.startNewGame(lobbyGame.lobbyGameId),
            ),
          );
        });
    final backButton = BackButton(
      onPressed: () {
        final game =
            lobbyCubit.state.gamesList?[lobbyCubit.state.gameIdToAction];
        if (game != null) {
          lobbyCubit.deleteGame(game.lobbyGameId);
        }
        context.go(LOBBY_ROUTE);
      },
    );
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        leading: backButton,
        title: Text('New Game'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        actions: [startButton],
      ),
      body: ExpandedChatPanel(
          expandedController: chatPanelExpandedVN,
          lobbyCubit: lobbyCubit,
          gameChatCubit: gameChatCubit,
          generalChatCubit: generalChatCubit,
          showGameMenu: false,
          child: BlocBuilder<LobbyCubit, LobbyState>(
              bloc: lobbyCubit,
              builder: (context, lobbyState) {
                if (lobbyState.notification != null)
                  showLobbyPopup(context, lobbyState.notification!, () {
                    lobbyCubit.clearNotification();
                  });
                logger.d('lobbyState changed: $lobbyState');
                final gameToShowGameOptions =
                    lobbyState.gamesList?[lobbyState.gameIdToAction];
                if (gameToShowGameOptions == null &&
                    lobbyState.status == LobbyStatus.SUCCESS) {
                  context.go(LOBBY_ROUTE);
                }
                return gameToShowGameOptions == null
                    ? SizedBox.shrink()
                    : GameOptionsView(
                        lobbyCubit: lobbyCubit,
                        lobbyGame: gameToShowGameOptions,
                        isOwnGame:
                            userId == gameToShowGameOptions.userIdCreatedBy,
                        allowColorChangeUserId:
                            gameToShowGameOptions.startedAt == null
                                ? userId
                                : null,
                      );
              })),
    );
  }
}
