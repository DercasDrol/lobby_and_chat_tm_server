import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tag_info.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/common/cards_list.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/selected_cards_model.dart';

class TabWithCards extends StatelessWidget {
  final SelectedCards selectedCards;
  final int? allCardsDiscount;
  final List<TagInfo>? tagsDiscounts;
  final PresentationTabInfo tabInfo;
  TabWithCards({
    this.allCardsDiscount,
    this.tagsDiscounts,
    required this.tabInfo,
    required this.selectedCards,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> cardWidgets = tabInfo.cards
            ?.map(
              (cardModel) {
                return ValueListenableBuilder<bool>(
                    valueListenable: selectedCards.cardNames[cardModel.name] ??
                        ValueNotifier(false),
                    builder:
                        (BuildContext context, bool isSelected, Widget? child) {
                      return CardView(
                        allCardsDiscount: allCardsDiscount,
                        tagsDiscounts: tagsDiscounts,
                        card: ClientCard.fromCardName(
                          cardModel.name,
                        ),
                        resourcesCount: cardModel.resources,
                        isSelected: isSelected,
                        isDeactivated: false,
                        onSelect: (isSelected0) {
                          if ((tabInfo.maxCards ?? 0) > 0) {
                            if ((tabInfo.maxCards ?? 0) == 1)
                              selectedCards.cardNames.forEach((key, value) {
                                value.value =
                                    cardModel.name == key && isSelected0;
                              });
                            else if (selectedCards.cardNames.values
                                        .where((e) => e.value)
                                        .toList()
                                        .length <
                                    (tabInfo.maxCards ?? 0) ||
                                !isSelected0)
                              selectedCards.cardNames[cardModel.name]!.value =
                                  isSelected0;
                          }
                        },
                      );
                    });
              },
            )
            .cast<Widget>()
            .toList() ??
        [];
    return CardListView(
      cards: [
        ...cardWidgets,
        ...tabInfo.disabledCards == null
            ? []
            : tabInfo.disabledCards!
                .map(
                  (cardModel) => CardView(
                    card: ClientCard.fromCardName(
                      cardModel.name,
                    ),
                    resourcesCount: cardModel.resources,
                    isSelected: false,
                    isDeactivated: true,
                  ),
                )
                .toList(),
      ],
    );
  }
}
