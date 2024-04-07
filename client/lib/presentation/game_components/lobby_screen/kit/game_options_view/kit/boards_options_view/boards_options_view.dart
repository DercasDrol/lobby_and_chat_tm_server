import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/domain/model/ma/RandomMAOptionType.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/boards_options_view/kit/boards_view.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/common/game_option_view.dart';

class BoardsOptionsView extends StatelessWidget {
  final CreateGameModel createGameModel;
  final bool isChangesAllowed;
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  const BoardsOptionsView({
    super.key,
    required this.createGameModel,
    required this.isChangesAllowed,
    required this.lobbyCubit,
    required this.lobbyGame,
  });

  @override
  Widget build(BuildContext context) {
    prepareOnChangeFn(fn) => isChangesAllowed ? fn : null;
    return Column(
      children: [
        Text('Boards Options', style: GAME_OPTIONS_CONSTANTS.blockTitleStyle),
        SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
        BoardsView(
          boards: CreateGameModel.boards,
          selectedBoard: createGameModel.board,
          onSelectedBoardChanged: prepareOnChangeFn(
            (board) {
              final newCreateGameModel =
                  lobbyGame.createGameModel.copyWith(board: board);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            },
          ),
        ),
        SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
        GameOptionContainer(
          padding:
              EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
          child: GameOptionView(
            lablePart1: "Randomize board tiles",
            type: GameOptionType.TOGGLE_BUTTON,
            descriptionUrl: RANDOMIZE_BOARDS_TILES_DESCRIPTION_URL,
            isSelected: lobbyGame.createGameModel.shuffleMapOption,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
              (__) {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      shuffleMapOption:
                          !lobbyGame.createGameModel.shuffleMapOption,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (lobbyGame.createGameModel.maxPlayers > 1) ...[
          SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
          GameOptionContainer(
            padding:
                EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
            child: GameOptionView(
              lablePart1: "Random Milestones/Awards",
              type: GameOptionType.DROPDOWN,
              useTwoLines: true,
              dropdownOptions:
                  RandomMAOptionType.values.map((v) => v.toString()).toList(),
              dropdownDefaultValueIdx: RandomMAOptionType.values
                  .indexOf(lobbyGame.createGameModel.randomMA),
              dropdownItemWidth: 150,
              descriptionUrl: RANDOM_MILESTOUNES_AWARDS_DESCRIPTION_URL,
              onDropdownOptionChangedOrOptionToggled:
                  prepareOnChangeFn((value) {
                final randomType = RandomMAOptionType.fromString(value);
                if (value != null && randomType != null) {
                  final newCreateGameModel =
                      lobbyGame.createGameModel.copyWith(randomMA: randomType);

                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(createGameModel: newCreateGameModel),
                  );
                }
              }),
            ),
          )
        ]
      ],
    );
  }
}
