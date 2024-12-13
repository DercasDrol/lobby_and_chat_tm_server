import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';

class ButtomButtonsView extends StatelessWidget {
  final bool isOwnGame;
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  const ButtomButtonsView(
      {super.key,
      required this.isOwnGame,
      required this.lobbyCubit,
      required this.lobbyGame});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isOwnGame && lobbyGame.startedAt == null)
          BottomButton(
            text: 'Cancel',
            onPressed: () {
              lobbyCubit.deleteGame(lobbyGame.lobbyGameId);
            },
          ),
        if (isOwnGame && lobbyGame.startedAt == null)
          BottomButton(
            text: lobbyGame.createGameModel.maxPlayers !=
                    lobbyGame.createGameModel.playersCount
                ? lobbyGame.createGameModel.playersCount == 1
                    ? 'Start solo game'
                    : 'Start game with ${lobbyGame.createGameModel.playersCount.toString()} players'
                : 'Start game',
            onPressed: () => lobbyCubit.startNewGame(lobbyGame.lobbyGameId),
          ),
        if (isOwnGame &&
            lobbyGame.startedAt == null &&
            lobbyGame.sharedAt == null &&
            lobbyGame.createGameModel.maxPlayers > 1)
          JustTheTooltip(
            enableFeedback: true,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            waitDuration: Duration(milliseconds: 400),
            content: Text(
                'This means that the game will be visible to other players\nand they will be able to join it.'),
            child: BottomButton(
              text: 'Publish game',
              onPressed: () => lobbyCubit.publicNewGame(lobbyGame.lobbyGameId),
            ),
          ),
        if (!isOwnGame && lobbyGame.startedAt == null)
          BottomButton(
            text: 'Leave game',
            onPressed: () {
              lobbyCubit.leaveNewGame(lobbyGame.lobbyGameId);
            },
          ),
      ],
    );
  }
}
