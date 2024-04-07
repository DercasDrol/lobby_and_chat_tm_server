import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/selected_cards_model.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/tabs/tab_with_cards.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/tabs/tab_with_options.dart';
import 'package:tab_container/tab_container.dart';

class ContainerWithTabs extends StatelessWidget {
  final PresentationTabsInfo tabsInfo;
  final SelectedCards leftTabSelectedCards;
  final SelectedCards midleTabSelectedCards;
  final SelectedCards rightTabSelectedCards;
  final TabContainerController tabController;

  final ValueNotifier<int?> rightTabSelectedOption;

  const ContainerWithTabs({
    required this.tabsInfo,
    required this.leftTabSelectedCards,
    required this.rightTabSelectedCards,
    required this.tabController,
    required this.rightTabSelectedOption,
    required this.midleTabSelectedCards,
  });

  @override
  Widget build(BuildContext context) {
    return TabContainer(
      controller: tabController,
      color: tabsInfo.playerColor.toColor(true),
      childPadding: EdgeInsets.all(5.0),
      tabEdge: TabEdge.top,
      children: [
        ...(tabsInfo.leftTabInfo?.cards == null &&
                tabsInfo.leftTabInfo?.disabledCards == null
            ? []
            : [
                TabWithCards(
                  tabInfo: tabsInfo.leftTabInfo!,
                  selectedCards: leftTabSelectedCards,
                  tagsDiscounts: (tabsInfo.leftTabInfo?.showDiscount ?? false)
                      ? tabsInfo.tagsDiscounts
                      : null,
                  allCardsDiscount:
                      (tabsInfo.leftTabInfo?.showDiscount ?? false)
                          ? tabsInfo.allCardsDiscount
                          : null,
                )
              ]),
        ...(tabsInfo.midleTabInfo?.cards == null &&
                tabsInfo.midleTabInfo?.disabledCards == null
            ? []
            : [
                TabWithCards(
                  tabInfo: tabsInfo.midleTabInfo!,
                  selectedCards: midleTabSelectedCards,
                  tagsDiscounts: (tabsInfo.midleTabInfo?.showDiscount ?? false)
                      ? tabsInfo.tagsDiscounts
                      : null,
                  allCardsDiscount:
                      (tabsInfo.midleTabInfo?.showDiscount ?? false)
                          ? tabsInfo.allCardsDiscount
                          : null,
                )
              ]),
        tabsInfo.rightTabInfo?.cards == null &&
                tabsInfo.rightTabInfo?.disabledCards == null
            ? tabsInfo.rightTabInfo?.options == null
                ? SizedBox.shrink()
                : TabWithOptions(
                    selectedOption: rightTabSelectedOption,
                    optionsInfo: tabsInfo.rightTabInfo!.options!,
                  )
            : TabWithCards(
                tabInfo: tabsInfo.rightTabInfo!,
                selectedCards: rightTabSelectedCards,
                tagsDiscounts: (tabsInfo.rightTabInfo?.showDiscount ?? false)
                    ? tabsInfo.tagsDiscounts
                    : null,
                allCardsDiscount: (tabsInfo.rightTabInfo?.showDiscount ?? false)
                    ? tabsInfo.allCardsDiscount
                    : null,
              ),
      ],
      tabs: [
        ...(tabsInfo.leftTabInfo?.cards == null &&
                tabsInfo.leftTabInfo?.disabledCards == null
            ? []
            : [tabsInfo.leftTabInfo?.tabTitle]),
        ...(tabsInfo.midleTabInfo?.cards == null &&
                tabsInfo.midleTabInfo?.disabledCards == null
            ? []
            : [tabsInfo.midleTabInfo?.tabTitle]),
        ...[tabsInfo.rightTabInfo?.tabTitle],
      ],
      selectedTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
      unselectedTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
