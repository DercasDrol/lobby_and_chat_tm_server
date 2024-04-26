import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/expansion_type.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/domain/model/ma/RandomMAOptionType.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class ExpansionsOptionsView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  final bool isChangesAllowed;
  const ExpansionsOptionsView({
    super.key,
    required this.lobbyCubit,
    required this.lobbyGame,
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

    final getMandatoryMoonTerraforming = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Mandatory Moon Terraforming",
            type: GameOptionType.TOGGLE_BUTTON,
            isSelected: lobbyGame.createGameModel.requiresMoonTrackCompletion,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
              final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                  requiresMoonTrackCompletion:
                      !lobbyGame.createGameModel.requiresMoonTrackCompletion);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }),
          ),
        );

    final getStandartMoonProjectVariant = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Standart Moon Project Variant",
            type: GameOptionType.TOGGLE_BUTTON,
            isSelected: lobbyGame.createGameModel.moonStandardProjectVariant,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
              final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                  moonStandardProjectVariant:
                      !lobbyGame.createGameModel.moonStandardProjectVariant);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }),
            descriptionUrl: MOON_STANDART_PROJECTS_DESCRIPTION_URL,
          ),
        );

    final getAgendas = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Agendas: ",
            type: GameOptionType.DROPDOWN,
            dropdownOptions:
                AgendaStyle.values.map((v) => v.toString()).toList(),
            dropdownDefaultValueIdx: AgendaStyle.values
                .indexOf(lobbyGame.createGameModel.politicalAgendasExtension),
            dropdownItemWidth: 100,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((value) {
              final agenda = AgendaStyle.fromString(value);
              if (value != null && agenda != null) {
                final newCreateGameModel = lobbyGame.createGameModel
                    .copyWith(politicalAgendasExtension: agenda);

                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(createGameModel: newCreateGameModel),
                );
              }
            }),
          ),
        );

    final getAltVenusBoard = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Alt. Venus Board",
            type: GameOptionType.TOGGLE_BUTTON,
            isSelected: lobbyGame.createGameModel.altVenusBoard,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
              final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                  altVenusBoard: !lobbyGame.createGameModel.altVenusBoard);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }),
            descriptionUrl: VENUS_ALTERNATIVE_BOARD_DESCRIPTION_URL,
          ),
        );

    final getVenusMA = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Venus Milestone/Award",
            type: GameOptionType.TOGGLE_BUTTON,
            isSelected: lobbyGame.createGameModel.includeVenusMA,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
              final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                  includeVenusMA: !lobbyGame.createGameModel.includeVenusMA);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }),
          ),
        );

    final getMandatoryVenusTerr = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Mandatory Venus Terraforming",
            type: GameOptionType.TOGGLE_BUTTON,
            isSelected: lobbyGame.createGameModel.requiresVenusTrackCompletion,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
              final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                  requiresVenusTrackCompletion:
                      !lobbyGame.createGameModel.requiresVenusTrackCompletion);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }),
            descriptionUrl: MANDATORY_VENUS_TERRAFORMING_DESCRIPTION_URL,
          ),
        );

    final getMerger = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Merger",
            image: Assets.expansionIcons.expansionIconPrelude.path,
            type: GameOptionType.TOGGLE_BUTTON,
            isSelected: lobbyGame.createGameModel.twoCorpsVariant,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
              final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                  twoCorpsVariant: !lobbyGame.createGameModel.twoCorpsVariant);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }),
            descriptionUrl: MERGER_DESCRIPTION_URL,
          ),
        );

    final getStartingCEOs = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart2: "Starting CEOs",
            type: GameOptionType.DROPDOWN,
            image: Assets.expansionIcons.expansionIconCeo.path,
            dropdownOptions:
                List.generate(6, (index) => (index + 1).toString()),
            dropdownDefaultValueIdx: lobbyGame.createGameModel.startingCeos - 1,
            dropdownItemWidth: 40,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((value) {
              if (value != null) {
                final newCreateGameModel = lobbyGame.createGameModel
                    .copyWith(startingCeos: int.parse(value));

                lobbyCubit.saveChangedOptions(
                  lobbyGame.copyWith(createGameModel: newCreateGameModel),
                );
              }
            }),
          ),
        );

    final getIncludeFanMA = () => addPaddingsAndBackground(
          GameOptionView(
            lablePart1: "Include fan Milestones/Awards",
            type: GameOptionType.TOGGLE_BUTTON,
            isSelected: lobbyGame.createGameModel.includeFanMA,
            onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
              final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                  includeFanMA: !lobbyGame.createGameModel.includeFanMA);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }),
          ),
        );
    final options = [
      if (lobbyGame.createGameModel.selectedExpansions
          .contains(ExpansionType.MOON)) ...[
        getMandatoryMoonTerraforming(),
        getStandartMoonProjectVariant(),
      ],
      if (lobbyGame.createGameModel.selectedExpansions
          .contains(ExpansionType.TURMOIL))
        getAgendas(),
      if (lobbyGame.createGameModel.selectedExpansions
          .contains(ExpansionType.VENUS_NEXT)) ...[
        getAltVenusBoard(),
        if (lobbyGame.createGameModel.maxPlayers > 1) ...[
          getVenusMA(),
          getMandatoryVenusTerr(),
        ],
      ],
      if (lobbyGame.createGameModel.selectedExpansions
          .contains(ExpansionType.PRELUDE))
        getMerger(),
      if (lobbyGame.createGameModel.randomMA != RandomMAOptionType.NONE)
        getIncludeFanMA(),
      if (lobbyGame.createGameModel.selectedExpansions
          .contains(ExpansionType.CEO))
        getStartingCEOs(),
    ];
    return options.isEmpty
        ? Container()
        : Column(
            children: [
              Text('Expansions Options',
                  style: GAME_OPTIONS_CONSTANTS.blockTitleStyle),
              ...options
            ],
          );
  }
}
