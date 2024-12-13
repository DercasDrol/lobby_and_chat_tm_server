import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class CommonOptionsView extends StatelessWidget {
  final LobbyGame lobbyGame;
  final LobbyCubit lobbyCubit;
  final bool isChangesAllowed;
  const CommonOptionsView({
    super.key,
    required this.lobbyGame,
    required this.lobbyCubit,
    required this.isChangesAllowed,
  });

  @override
  Widget build(BuildContext context) {
    prepareOnChangeFn(fn) => isChangesAllowed ? fn : null;
    final addPaddingsAndBackground = (child) => Container(
          padding:
              EdgeInsets.only(top: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
          child: GameOptionContainer(
            padding:
                EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
            child: child,
          ),
        );
    return Column(
      children: [
        SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
        Text('Options', style: GAME_OPTIONS_CONSTANTS.blockTitleStyle),
        if (lobbyGame.createGameModel.maxPlayers == 1)
          addPaddingsAndBackground(
            GameOptionView(
              lablePart1: "63 TR solo mode",
              type: GameOptionType.TOGGLE_BUTTON,
              descriptionUrl: SOLO_63_TR_MODE_DESCRIPTION_URL,
              isSelected: lobbyGame.createGameModel.soloTR,
              onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
                (__) {
                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(
                      createGameModel: lobbyGame.createGameModel.copyWith(
                        soloTR: !lobbyGame.createGameModel.soloTR,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        addPaddingsAndBackground(
          GameOptionView(
            lablePart2: "Starting Corporations",
            type: GameOptionType.DROPDOWN,
            dropdownItemWidth: 40,
            dropdownDefaultValueIdx:
                lobbyGame.createGameModel.startingCorporations - 1,
            dropdownOptions: const ["1", "2", "3", "4", "5", "6"],
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
              ((int, String)? value) {
                if (value != null &&
                    int.parse(value.$2) !=
                        lobbyGame.createGameModel.startingCorporations) {
                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(
                      createGameModel: lobbyGame.createGameModel.copyWith(
                        startingCorporations: int.parse(value.$2),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "World Government Terraforming",
            type: GameOptionType.TOGGLE_BUTTON,
            descriptionUrl: WORLD_GOVEREMENT_TERRAFORMING_DESCRIPTION_URL,
            isSelected: lobbyGame.createGameModel.solarPhaseOption,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
              (__) {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      solarPhaseOption:
                          !lobbyGame.createGameModel.solarPhaseOption,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Allow undo",
            type: GameOptionType.TOGGLE_BUTTON,
            descriptionUrl: ALLOW_UNDO_DESCRIPTION_URL,
            isSelected: lobbyGame.createGameModel.undoOption,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
              (__) {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      undoOption: !lobbyGame.createGameModel.undoOption,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Escape Velocity",
            type: GameOptionType.TOGGLE_BUTTON,
            descriptionUrl: ESCAPE_VELOCITY_DESCRIPTION_URL,
            isSelected: lobbyGame.createGameModel.escapeVelocityMode,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
              (__) {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      escapeVelocityMode:
                          !lobbyGame.createGameModel.escapeVelocityMode,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (lobbyGame.createGameModel.escapeVelocityMode) ...[
          addPaddingsAndBackground(
            GameOptionView(
              lablePart1: "After",
              lablePart2: "min",
              type: GameOptionType.DROPDOWN,
              dropdownItemWidth: 50,
              dropdownDefaultValueIdx:
                  lobbyGame.createGameModel.escapeVelocityThreshold ~/ 5,
              dropdownOptions:
                  List.generate(36, (index) => (index * 5).toString()),
              onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
                ((int, String)? value) {
                  if (value != null &&
                      int.parse(value.$2) !=
                          lobbyGame.createGameModel.escapeVelocityThreshold) {
                    lobbyCubit.saveChangedOptions(
                      lobbyGame.copyWith(
                        createGameModel: lobbyGame.createGameModel.copyWith(
                          escapeVelocityThreshold: int.parse(value.$2),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          addPaddingsAndBackground(
            GameOptionView(
              lablePart1: "Plus",
              lablePart2: "seconds per action",
              type: GameOptionType.DROPDOWN,
              dropdownItemWidth: 40,
              dropdownDefaultValueIdx:
                  lobbyGame.createGameModel.escapeVelocityBonusSeconds - 1,
              dropdownOptions:
                  List.generate(10, (index) => (index + 1).toString()),
              onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
                ((int, String)? value) {
                  if (value != null &&
                      int.parse(value.$2) !=
                          lobbyGame
                              .createGameModel.escapeVelocityBonusSeconds) {
                    lobbyCubit.saveChangedOptions(
                      lobbyGame.copyWith(
                        createGameModel: lobbyGame.createGameModel.copyWith(
                          escapeVelocityBonusSeconds: int.parse(value.$2),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              addPaddingsAndBackground(
                GameOptionView(
                  lablePart1: " Reduce",
                  lablePart2: "VP ",
                  type: GameOptionType.DROPDOWN,
                  dropdownItemWidth: 40,
                  dropdownDefaultValueIdx:
                      lobbyGame.createGameModel.escapeVelocityPenalty - 1,
                  dropdownOptions:
                      List.generate(10, (index) => (index + 1).toString()),
                  onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
                    ((int, String)? value) {
                      if (value != null &&
                          int.parse(value.$2) !=
                              lobbyGame.createGameModel.escapeVelocityPenalty) {
                        lobbyCubit.saveChangedOptions(
                          lobbyGame.copyWith(
                            createGameModel: lobbyGame.createGameModel.copyWith(
                              escapeVelocityPenalty: int.parse(value.$2),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              addPaddingsAndBackground(
                GameOptionView(
                  lablePart1: " every",
                  lablePart2: "min ",
                  type: GameOptionType.DROPDOWN,
                  dropdownItemWidth: 40,
                  dropdownDefaultValueIdx:
                      lobbyGame.createGameModel.escapeVelocityPeriod - 1,
                  dropdownOptions:
                      List.generate(10, (index) => (index + 1).toString()),
                  onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn(
                    ((int, String)? value) {
                      if (value != null &&
                          int.parse(value.$2) !=
                              lobbyGame.createGameModel.escapeVelocityPeriod) {
                        lobbyCubit.saveChangedOptions(
                          lobbyGame.copyWith(
                            createGameModel: lobbyGame.createGameModel.copyWith(
                              escapeVelocityPeriod: int.parse(value.$2),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        ]
      ],
    );
  }
}
