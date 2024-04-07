import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/common/game_option_view.dart';

class MultiplayerOptionsView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  final bool isChangesAllowed;

  const MultiplayerOptionsView({
    super.key,
    required this.lobbyGame,
    required this.lobbyCubit,
    required this.isChangesAllowed,
  });

  @override
  Widget build(BuildContext context) {
    prepareOnChangeFn(fn) => isChangesAllowed ? fn : null;
    return Column(children: [
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      Text('Multiplayer Options',
          style: GAME_OPTIONS_CONSTANTS.blockTitleStyle),
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GameOptionContainer(
            padding:
                EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
            child: GameOptionView(
              lablePart1: " Draft variant ",
              type: GameOptionType.TOGGLE_BUTTON,
              isSelected: lobbyGame.createGameModel.draftVariant,
              onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      draftVariant: !lobbyGame.createGameModel.draftVariant,
                    ),
                  ),
                );
              }),
            ),
          ),
          GameOptionContainer(
            padding:
                EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
            child: GameOptionView(
              lablePart1: " Initial Draft variant",
              type: GameOptionType.TOGGLE_BUTTON,
              descriptionUrl: INITIAL_DRAFT_VARIANTS_DESCRIPTION_URL,
              isSelected: lobbyGame.createGameModel.initialDraft,
              onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(
                    createGameModel: lobbyGame.createGameModel.copyWith(
                      initialDraft: !lobbyGame.createGameModel.initialDraft,
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      GameOptionContainer(
        padding: EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
        child: GameOptionView(
          lablePart1: "Show real-time VP",
          type: GameOptionType.TOGGLE_BUTTON,
          descriptionUrl: SHOW_REALTIME_VP_DESCRIPTION_URL,
          isSelected: lobbyGame.createGameModel.showOtherPlayersVP,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            lobbyCubit.saveChangedOptions(
              lobbyGame.copyWith(
                createGameModel: lobbyGame.createGameModel.copyWith(
                  showOtherPlayersVP:
                      !lobbyGame.createGameModel.showOtherPlayersVP,
                ),
              ),
            );
          }),
        ),
      ),
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      GameOptionContainer(
        padding: EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
        child: GameOptionView(
          lablePart1: "Fast mode",
          type: GameOptionType.TOGGLE_BUTTON,
          descriptionUrl: FAST_MODE_DESCRIPTION_URL,
          isSelected: lobbyGame.createGameModel.fastModeOption,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            lobbyCubit.saveChangedOptions(
              lobbyGame.copyWith(
                createGameModel: lobbyGame.createGameModel.copyWith(
                  fastModeOption: !lobbyGame.createGameModel.fastModeOption,
                ),
              ),
            );
          }),
        ),
      )
    ]);
  }
}
