import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/amounts_notifier.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/selected_cards_model.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/tabs/tab_with_amounts.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/tabs/tab_with_cards.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/tabs/tab_with_options.dart';
import 'package:tab_container/tab_container.dart';

class ContainerWithTabs extends StatefulWidget {
  final PresentationTabsInfo tabsInfo;
  final SelectedCards leftTabSelectedCards;
  final SelectedCards midleTabSelectedCards;
  final SelectedCards rightTabSelectedCards;
  final ValueNotifier<int> selectedTab;
  final ValueNotifier<int?> rightTabSelectedOption;
  final AmountsNotifier rightTabAmounts;

  const ContainerWithTabs({
    required this.tabsInfo,
    required this.leftTabSelectedCards,
    required this.rightTabSelectedCards,
    required this.rightTabSelectedOption,
    required this.midleTabSelectedCards,
    required this.selectedTab,
    required this.rightTabAmounts,
  });

  @override
  State<ContainerWithTabs> createState() => _ContainerWithTabsState();
}

class _ContainerWithTabsState extends State<ContainerWithTabs>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late List<Widget> tabsTitles;
  @override
  void initState() {
    super.initState();
    tabsTitles = [
      ...(widget.tabsInfo.leftTabInfo?.cards == null &&
              widget.tabsInfo.leftTabInfo?.disabledCards == null
          ? []
          : [Text(widget.tabsInfo.leftTabInfo?.tabTitle ?? " ")]),
      ...(widget.tabsInfo.midleTabInfo?.cards == null &&
              widget.tabsInfo.midleTabInfo?.disabledCards == null
          ? []
          : [Text(widget.tabsInfo.midleTabInfo?.tabTitle ?? " ")]),
      ...[Text(widget.tabsInfo.rightTabInfo?.tabTitle ?? " ")],
    ];
    _controller = TabController(vsync: this, length: tabsTitles.length);
    _controller.addListener(() {
      widget.selectedTab.value = _controller.index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabContainer(
      controller: _controller,
      color: widget.tabsInfo.playerColor.toColor(true),
      childPadding: EdgeInsets.all(5.0),
      tabEdge: TabEdge.top,
      children: [
        ...(widget.tabsInfo.leftTabInfo?.cards == null &&
                widget.tabsInfo.leftTabInfo?.disabledCards == null
            ? []
            : [
                TabWithCards(
                  tabInfo: widget.tabsInfo.leftTabInfo!,
                  selectedCards: widget.leftTabSelectedCards,
                  tagsDiscounts:
                      (widget.tabsInfo.leftTabInfo?.showDiscount ?? false)
                          ? widget.tabsInfo.tagsDiscounts
                          : null,
                  allCardsDiscount:
                      (widget.tabsInfo.leftTabInfo?.showDiscount ?? false)
                          ? widget.tabsInfo.allCardsDiscount
                          : null,
                )
              ]),
        ...(widget.tabsInfo.midleTabInfo?.cards == null &&
                widget.tabsInfo.midleTabInfo?.disabledCards == null
            ? []
            : [
                TabWithCards(
                  tabInfo: widget.tabsInfo.midleTabInfo!,
                  selectedCards: widget.midleTabSelectedCards,
                  tagsDiscounts:
                      (widget.tabsInfo.midleTabInfo?.showDiscount ?? false)
                          ? widget.tabsInfo.tagsDiscounts
                          : null,
                  allCardsDiscount:
                      (widget.tabsInfo.midleTabInfo?.showDiscount ?? false)
                          ? widget.tabsInfo.allCardsDiscount
                          : null,
                )
              ]),
        widget.tabsInfo.rightTabInfo?.cards == null &&
                widget.tabsInfo.rightTabInfo?.disabledCards == null
            ? widget.tabsInfo.rightTabInfo?.options == null
                ? widget.tabsInfo.rightTabInfo?.amounts == null
                    ? SizedBox.shrink()
                    : TabWithAmounts(amounts: widget.rightTabAmounts)
                : TabWithOptions(
                    selectedOption: widget.rightTabSelectedOption,
                    optionsInfo: widget.tabsInfo.rightTabInfo!.options!,
                  )
            : TabWithCards(
                tabInfo: widget.tabsInfo.rightTabInfo!,
                selectedCards: widget.rightTabSelectedCards,
                tagsDiscounts:
                    (widget.tabsInfo.rightTabInfo?.showDiscount ?? false)
                        ? widget.tabsInfo.tagsDiscounts
                        : null,
                allCardsDiscount:
                    (widget.tabsInfo.rightTabInfo?.showDiscount ?? false)
                        ? widget.tabsInfo.allCardsDiscount
                        : null,
              ),
      ],
      tabs: tabsTitles,
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
