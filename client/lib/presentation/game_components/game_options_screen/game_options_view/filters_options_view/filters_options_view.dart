import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';
import 'package:mars_flutter/domain/model/colonies/IColonyMetadata.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/expansion_type.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/core/common_future_widget.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/cards_view.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/filters_options_view/kit/checkboxes_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/filters_options_view/kit/common/filter_popup.dart';

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
    Function((int, String)?)? prepareOnChangeFn(fn) =>
        isChangesAllowed ? fn : null;
    addPaddingsAndBackground(child) => Container(
          padding:
              EdgeInsets.only(top: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
          child: GameOptionContainer(
            padding:
                EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
            child: child,
          ),
        );

    getCorporationsFilterButton(Map<CardName, ClientCard> cards) {
      final Set<ClientCard> corporations = cards.values
          .where(
              (ClientCard card) => [CardType.CORPORATION].contains(card.type))
          .toSet();
      final Set<ClientCard> initialSelectedCorporations = lobbyGame
          .createGameModel.customCorporations
          .map((corpName) => corporations.firstWhere(
              (corp) => corp.name == corpName,
              orElse: () =>
                  throw Exception('Corporation with name $corpName not found')))
          .toSet();
      return addPaddingsAndBackground(
        GameOptionView(
          lablePart1: initialSelectedCorporations.isNotEmpty
              ? "Corporation list: (${initialSelectedCorporations.length.toString()} selected)"
              : "Custom Corporation list",
          type: GameOptionType.TOGGLE_BUTTON,
          isSelected: initialSelectedCorporations.isNotEmpty,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            final ValueNotifier<Set<ClientCard>> selectedCorporationsN =
                ValueNotifier(initialSelectedCorporations);

            showFilterPopup(
              context: context,
              child: CheckboxesFilterView<ClientCard>(
                selectedElementsN: selectedCorporationsN,
                elements: corporations,
                getGameModule: (ClientCard element) => element.module,
                getName: (ClientCard element) => element.name.toString(),
                getImagePaths: (ClientCard element) => element.compatibility
                    .map((e) => e.toIconPath() ?? "undefined")
                    .toList(),
              ),
              onApply: () {
                final newCorps = selectedCorporationsN.value
                    .map((corp) => corp.name)
                    .toList();
                if (!ListEquality().equals(
                    newCorps, lobbyGame.createGameModel.customCorporations)) {
                  final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                    customCorporations: newCorps,
                  );

                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(createGameModel: newCreateGameModel),
                  );
                }
              },
            );
          }),
        ),
      );
    }

    getPreludesFilterButton(Map<CardName, ClientCard> cards) {
      final Set<ClientCard> preludes = cards.values
          .where((ClientCard card) => [CardType.PRELUDE].contains(card.type))
          .toSet();
      final Set<ClientCard> initialSelectedPreludes = lobbyGame
          .createGameModel.customPreludes
          .map((preludeName) => preludes.firstWhere(
              (prelude) => prelude.name == preludeName,
              orElse: () =>
                  throw Exception('Prelude with name $preludeName not found')))
          .toSet();
      return addPaddingsAndBackground(
        GameOptionView(
          lablePart1: initialSelectedPreludes.isNotEmpty
              ? "Preludes list: (${initialSelectedPreludes.length.toString()} selected)"
              : "Custom Preludes list",
          type: GameOptionType.TOGGLE_BUTTON,
          isSelected: initialSelectedPreludes.isNotEmpty,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            final ValueNotifier<Set<ClientCard>> selectedPreludesN =
                ValueNotifier(initialSelectedPreludes);
            showFilterPopup(
              context: context,
              child: CheckboxesFilterView<ClientCard>(
                selectedElementsN: selectedPreludesN,
                elements: preludes,
                getGameModule: (ClientCard element) => element.module,
                getName: (ClientCard element) => element.name.toString(),
                getImagePaths: (ClientCard element) => element.compatibility
                    .map((e) => e.toIconPath() ?? "undefined")
                    .toList(),
              ),
              onApply: () {
                final newPreludes = selectedPreludesN.value
                    .map((prelude) => prelude.name)
                    .toList();
                if (!ListEquality().equals(
                    newPreludes, lobbyGame.createGameModel.customPreludes)) {
                  final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                    customPreludes: newPreludes,
                  );

                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(createGameModel: newCreateGameModel),
                  );
                }
              },
            );
          }),
        ),
      );
    }

    getCEOsFilterButton(Map<CardName, ClientCard> cards) {
      final Set<ClientCard> seos = cards.values
          .where((ClientCard card) => [CardType.CEO].contains(card.type))
          .toSet();
      final Set<ClientCard> initialSelectedCEOs = lobbyGame
          .createGameModel.customCeos
          .map((ceoName) => seos.firstWhere((ceo) => ceo.name == ceoName,
              orElse: () =>
                  throw Exception('SEO with name $ceoName not found')))
          .toSet();
      return addPaddingsAndBackground(
        GameOptionView(
          lablePart1: initialSelectedCEOs.isNotEmpty
              ? "CEO list: (${initialSelectedCEOs.length.toString()} selected)"
              : "Custom CEO list",
          type: GameOptionType.TOGGLE_BUTTON,
          isSelected: initialSelectedCEOs.isNotEmpty,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            final ValueNotifier<Set<ClientCard>> selectedCEOsN =
                ValueNotifier(initialSelectedCEOs);
            showFilterPopup(
              context: context,
              child: CheckboxesFilterView<ClientCard>(
                selectedElementsN: selectedCEOsN,
                elements: seos,
                getGameModule: (ClientCard element) => element.module,
                getName: (ClientCard element) => element.name.toString(),
                getImagePaths: (ClientCard element) => element.compatibility
                    .map((e) => e.toIconPath() ?? "undefined")
                    .toList(),
              ),
              onApply: () {
                final newCeos =
                    selectedCEOsN.value.map((ceo) => ceo.name).toList();
                if (!ListEquality()
                    .equals(newCeos, lobbyGame.createGameModel.customCeos)) {
                  final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                    customCeos: newCeos,
                  );

                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(createGameModel: newCreateGameModel),
                  );
                }
              },
            );
          }),
        ),
      );
    }

    getColoniesFilterButton(Map<ColonyName, IColonyMetadata> colonies) {
      final Set<IColonyMetadata> coloniesSet = colonies.values.toSet();
      final Set<IColonyMetadata> initialSelectedColonies = lobbyGame
          .createGameModel.customColonies
          .map((colonyName) => coloniesSet.firstWhere(
              (colony) => colony.name == colonyName,
              orElse: () =>
                  throw Exception('Prelude with name $colonyName not found')))
          .toSet();
      return addPaddingsAndBackground(
        GameOptionView(
          lablePart1: initialSelectedColonies.isNotEmpty
              ? "Colonies list: (${initialSelectedColonies.length.toString()} selected)"
              : "Custom Colonies list",
          type: GameOptionType.TOGGLE_BUTTON,
          isSelected: initialSelectedColonies.isNotEmpty,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            final ValueNotifier<Set<IColonyMetadata>> selectedColoniesN =
                ValueNotifier(initialSelectedColonies);
            showFilterPopup(
              context: context,
              child: CheckboxesFilterView<IColonyMetadata>(
                selectedElementsN: selectedColoniesN,
                elements: coloniesSet,
                getGameModule: (IColonyMetadata element) => element.module,
                getName: (IColonyMetadata element) => element.name.toString(),
                getImagePaths: (IColonyMetadata element) => [],
              ),
              onApply: () {
                final newColonies = selectedColoniesN.value
                    .map((colony) => colony.name)
                    .toList();
                if (!ListEquality().equals(
                    newColonies, lobbyGame.createGameModel.customColonies)) {
                  final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                    customColonies: newColonies,
                  );

                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(createGameModel: newCreateGameModel),
                  );
                }
              },
            );
          }),
        ),
      );
    }

    getIncludedCardsFilterButton(Map<CardName, ClientCard> cards) {
      final Set<ClientCard> initialSelectedCards = lobbyGame
          .createGameModel.includedCards
          .map((cardName) => cards.values.firstWhere(
              (card) => card.name == cardName,
              orElse: () =>
                  throw Exception('Card with name $cardName not found')))
          .toSet();

      return addPaddingsAndBackground(
        GameOptionView(
          lablePart1: initialSelectedCards.isNotEmpty
              ? "Included Cards: (${initialSelectedCards.length.toString()} selected)"
              : "Include some cards",
          type: GameOptionType.TOGGLE_BUTTON,
          isSelected: initialSelectedCards.isNotEmpty,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            final ValueNotifier<Set<ClientCard>> selectedCardsN =
                ValueNotifier(initialSelectedCards);

            showFilterPopup(
              context: context,
              child: Material(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: CardsView(
                    selectedCardsN: selectedCardsN,
                    cardsF: ClientCard.allCards,
                    targetTypes: [
                      CardType.EVENT,
                      CardType.AUTOMATED,
                      CardType.ACTIVE
                    ],
                  )),
              onApply: () {
                final newSelectedCards =
                    selectedCardsN.value.map((card) => card.name).toList();
                if (!ListEquality().equals(newSelectedCards,
                    lobbyGame.createGameModel.includedCards)) {
                  final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                    includedCards: newSelectedCards,
                  );

                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(createGameModel: newCreateGameModel),
                  );
                }
              },
            );
          }),
        ),
      );
    }

    getExcludedCardsFilterButton(Map<CardName, ClientCard> cards) {
      final Set<ClientCard> initialSelectedCards = lobbyGame
          .createGameModel.bannedCards
          .map((cardName) => cards.values.firstWhere(
              (card) => card.name == cardName,
              orElse: () =>
                  throw Exception('Card with name $cardName not found')))
          .toSet();

      return addPaddingsAndBackground(
        GameOptionView(
          lablePart1: initialSelectedCards.isNotEmpty
              ? "Excluded Cards: (${initialSelectedCards.length.toString()} selected)"
              : "Exclude some cards",
          type: GameOptionType.TOGGLE_BUTTON,
          isSelected: initialSelectedCards.isNotEmpty,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            final ValueNotifier<Set<ClientCard>> selectedCardsN =
                ValueNotifier(initialSelectedCards);

            showFilterPopup(
              context: context,
              child: Material(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: CardsView(
                    selectedCardsN: selectedCardsN,
                    cardsF: ClientCard.allCards,
                    targetTypes: [
                      CardType.EVENT,
                      CardType.AUTOMATED,
                      CardType.ACTIVE
                    ],
                  )),
              onApply: () {
                final newSelectedCards =
                    selectedCardsN.value.map((card) => card.name).toList();
                if (!ListEquality().equals(
                    newSelectedCards, lobbyGame.createGameModel.bannedCards)) {
                  final newCreateGameModel = lobbyGame.createGameModel.copyWith(
                    bannedCards: newSelectedCards,
                  );

                  lobbyCubit.saveChangedOptions(
                    lobbyGame.copyWith(createGameModel: newCreateGameModel),
                  );
                }
              },
            );
          }),
        ),
      );
    }

    getRemoveNegativeGlobalEventsButton() {
      return addPaddingsAndBackground(
        GameOptionView(
          lablePart1: "Remove negative Global Events",
          type: GameOptionType.TOGGLE_BUTTON,
          isSelected:
              lobbyGame.createGameModel.removeNegativeGlobalEventsOption,
          onDropdownOptionChangedOrOptionToggled: prepareOnChangeFn((__) {
            lobbyCubit.saveChangedOptions(
              lobbyGame.copyWith(
                createGameModel: lobbyGame.createGameModel.copyWith(
                  removeNegativeGlobalEventsOption: !lobbyGame
                      .createGameModel.removeNegativeGlobalEventsOption,
                ),
              ),
            );
          }),
        ),
      );
    }

    return CommonFutureWidget<Map<CardName, ClientCard>>(
        future: ClientCard.allCards,
        getContentView: (cards) {
          return CommonFutureWidget<Map<ColonyName, IColonyMetadata>>(
            future: IColonyMetadata.allColoniesMetadata,
            getContentView: (colonies) {
              return Column(children: [
                SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
                Text('Filter', style: GAME_OPTIONS_CONSTANTS.blockTitleStyle),
                getCorporationsFilterButton(cards),
                if (lobbyGame.createGameModel.selectedExpansions
                    .contains(ExpansionType.PRELUDE))
                  getPreludesFilterButton(cards),
                getIncludedCardsFilterButton(cards),
                getExcludedCardsFilterButton(cards),
                if (lobbyGame.createGameModel.selectedExpansions
                    .contains(ExpansionType.CEO))
                  getCEOsFilterButton(cards),
                if (lobbyGame.createGameModel.selectedExpansions
                    .contains(ExpansionType.COLONIES))
                  getColoniesFilterButton(colonies),
                if (lobbyGame.createGameModel.selectedExpansions
                    .contains(ExpansionType.TURMOIL))
                  getRemoveNegativeGlobalEventsButton(),
              ]);
            },
          );
        });
  }
}
