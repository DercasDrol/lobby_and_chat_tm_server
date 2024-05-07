import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/core/common_future_widget.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/filters_options_view/kit/corporations_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/filters_options_view/kit/filter_popup.dart';

class FiltersOptionsView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  final bool isChangesAllowed;

  const FiltersOptionsView({
    super.key,
    required this.lobbyGame,
    required this.lobbyCubit,
    required this.isChangesAllowed,
  });

  @override
  Widget build(BuildContext context) {
    return CommonFutureWidget<Map<CardName, ClientCard>>(
      future: ClientCard.allCards,
      getContentView: (cards) {
        final Set<ClientCard> corporations = cards.values
            .where(
                (ClientCard card) => [CardType.CORPORATION].contains(card.type))
            .toSet();
        final Set<ClientCard> initialSelectedCorporations = lobbyGame
            .createGameModel.customCorporations
            .map((corpName) => corporations.firstWhere(
                (corp) => corp.name == corpName,
                orElse: () => throw Exception(
                    'Corporation with name $corpName not found')))
            .toSet();

        Function(String?)? prepareOnChangeFn(fn) =>
            isChangesAllowed ? fn : null;

        return Column(children: [
          SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
          Text('Filter', style: GAME_OPTIONS_CONSTANTS.blockTitleStyle),
          SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
          GameOptionContainer(
            padding:
                EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
            child: GameOptionView(
              lablePart1: initialSelectedCorporations.isNotEmpty
                  ? "Corporation list (${initialSelectedCorporations.length.toString()} selected)"
                  : "Custom Corporation list",
              type: GameOptionType.TOGGLE_BUTTON,
              isSelected: initialSelectedCorporations.isNotEmpty,
              onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
                final ValueNotifier<Set<ClientCard>> selectedCorporationsN =
                    ValueNotifier(initialSelectedCorporations);

                showFilterPopup(
                  context: context,
                  child: CorporationsFilterView(
                    selectedCorporationsN: selectedCorporationsN,
                    corporations: corporations,
                  ),
                  onApply: () {
                    final newCreateGameModel =
                        lobbyGame.createGameModel.copyWith(
                      customCorporations: selectedCorporationsN.value
                          .map((corp) => corp.name)
                          .toList(),
                    );

                    lobbyCubit.saveChangedOptions(
                      lobbyGame.copyWith(createGameModel: newCreateGameModel),
                    );
                  },
                );
              }),
            ),
          ),
        ]);
      },
    );
  }
}
