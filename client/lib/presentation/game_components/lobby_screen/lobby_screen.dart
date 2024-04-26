import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/chat_view/chat_view.dart';
import 'package:mars_flutter/presentation/game_components/common/stars_background.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/game_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/lobby_view/lobby_view.dart';

//list of the games in left area, and chat in right area
class MainLobbyScreen extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  const MainLobbyScreen({
    super.key,
    required this.lobbyCubit,
    required this.gameChatCubit,
    required this.generalChatCubit,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final userId = lobbyCubit.userId;
    final leftPartHeight = 600.0;
    final leftPartWidth = 580.0;
    return Scaffold(
      body: Stack(
        children: [
          StarsBackground(),
          Center(
            child: FittedBox(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                BlocBuilder<LobbyCubit, LobbyState>(
                    bloc: lobbyCubit,
                    buildWhen: (pState, state) {
                      final needGoToGame = lobbyCubit.needGoToGame;
                      if (needGoToGame) {
                        context.go(GAME_ROUTE);
                      }
                      return !needGoToGame;
                    },
                    builder: (context, lobbyState) {
                      logger.d('lobbyState changed: $lobbyState');

                      final gameToShowGameOptions =
                          lobbyState.gamesList?[lobbyState.gameIdToAction];

                      return gameToShowGameOptions == null
                          ? LobbyView(
                              lobbyCubit: lobbyCubit,
                              width: leftPartWidth,
                              height: leftPartHeight,
                            )
                          : GameOptionsView(
                              lobbyCubit: lobbyCubit,
                              width: leftPartWidth,
                              height: leftPartHeight,
                              lobbyGame: gameToShowGameOptions,
                              isOwnGame: userId ==
                                  gameToShowGameOptions.userIdCreatedBy,
                              allowColorChangeUserId:
                                  gameToShowGameOptions.startedAt == null
                                      ? userId
                                      : null,
                            );
                    }),
                SizedBox.fromSize(size: Size(10, 10)),
                ChatView(
                  gameChatCubit: gameChatCubit,
                  generalChatCubit: generalChatCubit,
                  width: 300,
                  height: leftPartHeight,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
