import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/common/options_miniatures_row.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/game_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/common/game_option_view.dart';

class GameRow extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame game;

  const GameRow({
    super.key,
    required this.game,
    required this.lobbyCubit,
  });

  @override
  Widget build(BuildContext context) {
    final board = game.createGameModel.board;

    final gameOptionsView = GameOptionsView(
      lobbyCubit: lobbyCubit,
      width: 525,
      height: 400,
      lobbyGame: game,
      isOwnGame: false,
      isForTooltip: true,
    );

    final userNamesTextRow = Padding(
      padding: EdgeInsets.only(left: 5.0),
      child: Text(
        game.createGameModel.players.map((e) => e.name).toString(),
        style: GAME_OPTIONS_CONSTANTS.blockTitleStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final playersCount = GameOptionView(
      image: Assets.misc.delegate.path,
      lablePart1: game.createGameModel.players.length.toString() +
          (!game.isStarted
              ? ' / ' + game.createGameModel.maxPlayers.toString()
              : ""),
      fontColor: GAME_OPTIONS_CONSTANTS.dropdownSelectedItemTextColor,
      type: GameOptionType.SIMPLE,
    );

    final boardView = Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: GameOptionView(
        imageAsWidget: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text('⬢', style: TextStyle(color: board.color, fontSize: 20)),
        ),
        lablePart1: board.name,
        fontColor: GAME_OPTIONS_CONSTANTS.dropdownSelectedItemTextColor,
        type: GameOptionType.SIMPLE,
      ),
    );

    return GameOptionContainer(
      padding: EdgeInsets.only(
        right: 5.0,
      ),
      margin: EdgeInsets.symmetric(vertical: 3.0),
      child: JustTheTooltip(
        enableFeedback: true,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        waitDuration: Duration(milliseconds: 400),
        content: gameOptionsView,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 336.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  userNamesTextRow,
                  SizedBox(height: 3.0),
                  OptionMiniaturesRow(
                    options: game.createGameModel.selectedOptionsMiniatures,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 150.0,
                  child: Column(children: [
                    SizedBox(height: 7.0),
                    playersCount,
                    boardView,
                  ]),
                ),
                SizedBox(
                    width: 79.0,
                    child: game.isPlayerCanJoin || game.isStarted
                        ? BottomButton(
                            text: !game.isStarted
                                ? 'Join'
                                : game.isPlayerJoined(lobbyCubit.userId) &&
                                        !game.isFinished
                                    ? "Continue"
                                    : 'Watch',
                            onPressed: () {
                              if (!game.isStarted && game.isPlayerCanJoin) {
                                lobbyCubit.joinNewGame(game.lobbyGameId);
                              } else if (game
                                      .isPlayerJoined(lobbyCubit.userId) &&
                                  !game.isFinished) {
                                lobbyCubit.continueGame(game.lobbyGameId);
                              } else if (game.spectatorId != null) {
                                lobbyCubit.setGameActionType(
                                    GameActionType.SHOW_SPECTATOR_GAME,
                                    game.lobbyGameId);
                              }
                            })
                        : SizedBox.shrink()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
