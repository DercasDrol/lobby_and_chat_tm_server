import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/common/options_miniatures_row.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/game_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class GameRow extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame game;
  final double width;

  const GameRow(
      {super.key,
      required this.game,
      required this.lobbyCubit,
      required this.width});

  @override
  Widget build(BuildContext context) {
    final board = game.createGameModel.board;

    final gameOptionsView = GameOptionsView(
      lobbyCubit: lobbyCubit,
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
    final gen = game.finalState?.game.generation;
    final playersCount = GameOptionView(
      images: [Assets.misc.delegate.path],
      lablePart1: game.createGameModel.players.length.toString() +
          (!game.isStarted
              ? ' / ' + game.createGameModel.maxPlayers.toString()
              : ""),
      lablePart2: gen != null ? ' / Gen: $gen' : null,
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

    final timerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: 13,
      fontFeatures: <FontFeature>[
        FontFeature.tabularFigures(),
      ],
    );
    final timerView = game.deathAt != null
        ? TimerCountdown(
            format: CountDownTimerFormat.daysHoursMinutesSeconds,
            endTime: game.deathAt!,
            timeTextStyle: timerStyle,
            colonsTextStyle: timerStyle,
            enableDescriptions: false,
            spacerWidth: 0,
          )
        : SizedBox.shrink();
    final buttonPartWidth = 79.0;
    final boardPartWidth = 150.0;
    final expansionMinWidth = 250.0;
    final userNamesPartWidth = //width > expansionMinWidth + boardPartWidth + buttonPartWidth + 5.0 ?
        max(width - boardPartWidth - buttonPartWidth - 5.0, expansionMinWidth);
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
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: userNamesPartWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  userNamesTextRow,
                  SizedBox(height: 3.0),
                  FittedBox(
                      child: OptionMiniaturesRow(
                    options: game.createGameModel.selectedOptionsMiniatures,
                  )),
                ],
              ),
            ),
            SizedBox(
              width: boardPartWidth,
              child: Column(children: [
                SizedBox(height: 7.0),
                playersCount,
                boardView,
              ]),
            ),
            SizedBox(
              width: buttonPartWidth,
              child: Column(children: [
                game.isDead
                    ? Text('Game is Dead',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red))
                    : Column(children: [
                        game.isPlayerCanJoin || game.isStarted
                            ? BottomButton(
                                text: !game.isStarted
                                    ? 'Join'
                                    : game.isPlayerJoined(lobbyCubit.userId) &&
                                            !game.isFinished
                                        ? "Continue"
                                        : game.isFinished
                                            ? 'Results'
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
                            : SizedBox.shrink(),
                        if (game.deathAt != null) timerView
                      ]),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
