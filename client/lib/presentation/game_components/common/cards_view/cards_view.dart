import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/presentation/core/common_future_widget.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/core/widget_size.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/kit/card_type_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/kit/modules_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/kit/tags_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';

class CardsView extends StatelessWidget {
  final Future<Map<CardName, ClientCard>> cardsF;
  final List<CardType> targetTypes;
  final ValueNotifier<Set<ClientCard>>? selectedCardsN;
  const CardsView({
    super.key,
    required this.cardsF,
    required this.targetTypes,
    this.selectedCardsN,
  });

  @override
  Widget build(BuildContext context) {
    final scrollContriller = ScrollController();
    final useSavedFilters = selectedCardsN == null;

    final ValueNotifier<List<Tag>> selectedTagsN = ValueNotifier(
      localStorage.getItem('selectedTags') == null || !useSavedFilters
          ? Tag.values
          : jsonDecode(localStorage.getItem('selectedTags') ?? '[]')
              .map((e) => Tag.fromString(e))
              .cast<Tag>()
              .toList(),
    );
    if (useSavedFilters)
      selectedTagsN.addListener(() {
        localStorage.setItem('selectedTags', json.encode(selectedTagsN.value));
      });
    logger.d(" selectedTypes: ${localStorage.getItem('selectedTypes')}");
    final ValueNotifier<List<CardType>> selectedTypesN = ValueNotifier(
      localStorage.getItem('selectedTypes') == null || !useSavedFilters
          ? targetTypes
          : json
              .decode(localStorage.getItem('selectedTypes') ?? '[]')
              .map((e) => CardType.fromString(e))
              .cast<CardType>()
              .toList(),
    );
    if (useSavedFilters)
      selectedTypesN.addListener(() {
        final res = selectedTypesN.value;
        logger.d("selectedTypesN.value: ${res}");
        localStorage.setItem('selectedTypes', json.encode(res));
      });

    final ValueNotifier<List<GameModule>> selectedModulesN = ValueNotifier(
      localStorage.getItem('selectedModules') == null || !useSavedFilters
          ? GameModule.values
          : jsonDecode(localStorage.getItem('selectedModules') ?? '[]')
              .map((e) => GameModule.fromString(e))
              .cast<GameModule>()
              .toList(),
    );
    if (useSavedFilters)
      selectedModulesN.addListener(() {
        localStorage.setItem(
            'selectedModules', json.encode(selectedModulesN.value));
      });

    final ValueNotifier<String?> textFilterN = ValueNotifier(
        useSavedFilters ? localStorage.getItem('textFilter') : null);
    if (useSavedFilters)
      textFilterN.addListener(() {
        localStorage.setItem('textFilter', textFilterN.value.toString());
      });

    final ValueNotifier<double> headerHeightN = ValueNotifier(2300.0);

    Widget getHeaderView() => Container(
          decoration: BoxDecoration(
            color: Colors.grey[700],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: WidgetSize(
            onChange: (Size size) {
              logger.d(size);
              headerHeightN.value = size.height + 40.0;
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (selectedCardsN != null)
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: selectedCardsN!.value
                          .map((card) => Chip(
                                label: Text(card.name.toString()),
                                onDeleted: () {
                                  selectedCardsN!.value = selectedCardsN!.value
                                      .where((element) => element != card)
                                      .toSet();
                                },
                              ))
                          .toList(),
                    )),
              Container(
                  margin: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TextField(
                    onChanged: (text) {
                      textFilterN.value = text;
                    },
                    controller: TextEditingController()
                      ..text = textFilterN.value ?? '',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                  )),
              ModulesFilterView(selectedModulesN: selectedModulesN),
              CardTypeFilterView(
                  selectedCardTypesN: selectedTypesN, targetTypes: targetTypes),
              TagsFilterView(selectedTagsN: selectedTagsN),
              SizedBox(height: 5.0),
            ]),
          ),
        );

    Widget getCardsGrid(filteredCards, constraints) {
      const double cardWidth = CARD_WIDTH * 1.1;
      final int crossAxisCount0 = (constraints.maxWidth - 40) / cardWidth ~/ 1;
      final int crossAxisCount = crossAxisCount0 < 1 ? 1 : crossAxisCount0;
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 300.0,
          crossAxisCount: crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final card = filteredCards[index];
            final ValueNotifier<bool> isSelectedN =
                ValueNotifier(selectedCardsN?.value.contains(card) ?? false);
            final onSelect = selectedCardsN != null
                ? (isSelected) {
                    selectedCardsN!.value = isSelected
                        ? [...selectedCardsN!.value, card]
                            .cast<ClientCard>()
                            .toSet()
                        : selectedCardsN!.value
                            .where((element) => element != card)
                            .toSet();
                    isSelectedN.value = isSelected;
                  }
                : null;
            final listener = () {
              if (selectedCardsN!.value.contains(card) != isSelectedN.value)
                isSelectedN.value = !isSelectedN.value;
            };
            selectedCardsN?.addListener(listener);
            return Disposer(
                dispose: () {
                  selectedCardsN?.removeListener(listener);
                },
                child: ValueListenableBuilder(
                    valueListenable: isSelectedN,
                    builder: (context, isSelected, child) => CardView(
                          card: card,
                          isSelected: isSelected,
                          isDeactivated: false,
                          onSelect: onSelect,
                        )));
          },
          childCount: filteredCards.length,
        ),
      );
    }

    List<ClientCard> filterCards(
      Map<CardName, ClientCard> allCards,
      List<CardType> selectedTypes,
      List<GameModule> selectedModules,
      List<Tag> selectedTags,
      String? textFilter,
    ) =>
        allCards.values.where((cardInfo) {
          return selectedTypes.contains(cardInfo.type) &&
              selectedModules.contains(cardInfo.module) &&
              (selectedTags.any((tag) => cardInfo.tags.contains(tag)) ||
                  cardInfo.tags.isEmpty) &&
              (textFilter == null ||
                  cardInfo.name
                      .toString()
                      .toLowerCase()
                      .contains(textFilter.toLowerCase()));
        }).toList()
          ..sort(
            (a, b) => a.name.toString().compareTo(b.name.toString()),
          );

    Widget getContentView(Map<CardName, ClientCard> allCards) {
      return LayoutBuilder(builder: (context, constraints) {
        headerHeightN.value = 2300.0;
        return ValueListenableBuilder(
          valueListenable: selectedCardsN ?? ValueNotifier({}),
          builder: (context, selectedCards, child) => Scrollbar(
            controller: scrollContriller,
            thickness: 15.0,
            child: CustomScrollView(controller: scrollContriller, slivers: [
              ValueListenableBuilder(
                valueListenable: headerHeightN,
                builder: (context, headerHeight, child) =>
                    SliverPersistentHeader(
                  pinned: false,
                  floating: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: headerHeight,
                    maxHeight: headerHeight,
                    child: getHeaderView(),
                  ),
                ),
              ),
              ValueListenableBuilder<List<Tag>>(
                  valueListenable: selectedTagsN,
                  builder: (context, selectedTags, child) {
                    return ValueListenableBuilder<List<CardType>>(
                        valueListenable: selectedTypesN,
                        builder: (context, selectedTypes, child) {
                          return ValueListenableBuilder<List<GameModule>>(
                              valueListenable: selectedModulesN,
                              builder: (context, selectedModules, child) {
                                return ValueListenableBuilder<String?>(
                                    valueListenable: textFilterN,
                                    builder: (context, textFilter, child) {
                                      final filteredCards = filterCards(
                                        allCards,
                                        selectedTypes,
                                        selectedModules,
                                        selectedTags,
                                        textFilter,
                                      );
                                      return getCardsGrid(
                                        filteredCards,
                                        constraints,
                                      );
                                    });
                              });
                        });
                  })
            ]),
          ),
        );
      });
    }

    return Center(
      child: CommonFutureWidget<Map<CardName, ClientCard>>(
        future: cardsF,
        getContentView: getContentView,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
