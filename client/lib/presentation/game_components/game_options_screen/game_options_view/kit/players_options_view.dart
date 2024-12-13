import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class PlayersOptionsView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  final bool isChangesAllowed;
  const PlayersOptionsView({
    super.key,
    required this.lobbyCubit,
    required this.lobbyGame,
    required this.isChangesAllowed,
  });

  @override
  Widget build(BuildContext context) {
    final players = lobbyGame.createGameModel.players;
    prepareOnChangeFn(fn) => isChangesAllowed ? fn : null;
    return Column(children: [
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      Text(
        'Players Options',
        style: GAME_OPTIONS_CONSTANTS.blockTitleStyle,
      ),
      if (lobbyGame.createGameModel.maxPlayers > 1) ...[
        SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
        GameOptionContainer(
          child: GameOptionView(
            lablePart1: "First player: ",
            type: GameOptionType.DROPDOWN,
            dropdownItemWidth: 131,
            dropdownOptions: ["Random", ...players.map((e) => e.name).toList()],
            onDropdownOptionChangedOrOptionToggled:
                prepareOnChangeFn(((int, String)? value) {
              if (value?.$2 == "Random" &&
                  !lobbyGame.createGameModel.randomFirstPlayer) {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      randomFirstPlayer: true,
                    ),
                  ),
                );
              } else if (value?.$2 != "Random") {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      randomFirstPlayer: false,
                      players: players.map((e) {
                        if (e.name == value?.$2) {
                          return e.copyWith(first: true);
                        } else {
                          return e.copyWith(first: false);
                        }
                      }).toList(),
                    ),
                  ),
                );
              }
            }),
            dropdownDefaultValueIdx: lobbyGame.createGameModel.randomFirstPlayer
                ? 0
                : players.indexWhere((element) => element.first) + 1,
          ),
        ),
      ],
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      GameOptionContainer(
        child: GameOptionView(
          lablePart1: "Max players count: ",
          type: GameOptionType.DROPDOWN,
          dropdownOptions: List.generate(6 - (players.length - 1), (index) {
            return (index + players.length).toString();
          }),
          dropdownDefaultValueIdx:
              max(lobbyGame.createGameModel.maxPlayers - players.length, 0),
          onDropdownOptionChangedOrOptionToggled:
              prepareOnChangeFn(((int, String)? value) {
            if (value != null &&
                int.parse(value.$2) != lobbyGame.createGameModel.maxPlayers)
              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(
                  createGameModel: lobbyGame.createGameModel.copyWith(
                    maxPlayers: int.parse(value.$2),
                  ),
                ),
              );
          }),
        ),
      ),
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
    ]);
  }
}
