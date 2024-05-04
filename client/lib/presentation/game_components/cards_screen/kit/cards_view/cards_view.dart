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
import 'package:mars_flutter/presentation/core/widget_size.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/kit/card_type_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/kit/modules_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/kit/tags_filter_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';

class CardsView extends StatelessWidget {
  final Future<Map<CardName, ClientCard>> cardsF;
  final List<CardType> targetTypes;
  const CardsView({super.key, required this.cardsF, required this.targetTypes});

  @override
  Widget build(BuildContext context) {
    final scrollContriller = ScrollController();
    final ValueNotifier<List<Tag>> selectedTagsN = ValueNotifier(
      localStorage.getItem('selectedTags') == null
          ? Tag.values
          : jsonDecode(localStorage.getItem('selectedTags') ?? '[]')
              .map((e) => Tag.fromString(e))
              .cast<Tag>()
              .toList(),
    );
    selectedTagsN.addListener(() {
      localStorage.setItem('selectedTags', json.encode(selectedTagsN.value));
    });
    logger.d(" selectedTypes: ${localStorage.getItem('selectedTypes')}");
    final ValueNotifier<List<CardType>> selectedTypesN = ValueNotifier(
      localStorage.getItem('selectedTypes') == null
          ? CardType.values
          : json
              .decode(localStorage.getItem('selectedTypes') ?? '[]')
              .map((e) => CardType.fromString(e))
              .cast<CardType>()
              .toList(),
    );
    selectedTypesN.addListener(() {
      final res = selectedTypesN.value;
      logger.d("selectedTypesN.value: ${res}");
      localStorage.setItem('selectedTypes', json.encode(res));
    });

    final ValueNotifier<List<GameModule>> selectedModulesN = ValueNotifier(
      localStorage.getItem('selectedModules') == null
          ? GameModule.values
          : jsonDecode(localStorage.getItem('selectedModules') ?? '[]')
              .map((e) => GameModule.fromString(e))
              .cast<GameModule>()
              .toList(),
    );
    selectedModulesN.addListener(() {
      localStorage.setItem(
          'selectedModules', json.encode(selectedModulesN.value));
    });

    final ValueNotifier<String?> textFilterN =
        ValueNotifier(localStorage.getItem('textFilter'));
    textFilterN.addListener(() {
      localStorage.setItem('textFilter', textFilterN.value.toString());
    });

    final ValueNotifier<double> headerHeightN = ValueNotifier(2300.0);
    Widget getContentView(Map<CardName, ClientCard> allCards) {
      return LayoutBuilder(builder: (context, constraints) {
        headerHeightN.value = 2300.0;
        return Scrollbar(
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
                    child: Container(
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
                          headerHeightN.value = size.height;
                        },
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
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
                              selectedCardTypesN: selectedTypesN),
                          TagsFilterView(selectedTagsN: selectedTagsN),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(padding: EdgeInsets.only(top: 20)),
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
                                      final filteredCards = allCards.values
                                          .where((cardInfo) {
                                        if (cardInfo.name == CardName.INCITE) {
                                          logger.d('cardInfo: $cardInfo');
                                        }
                                        return selectedTypes
                                                .contains(cardInfo.type) &&
                                            selectedModules
                                                .contains(cardInfo.module) &&
                                            (selectedTags.any((tag) => cardInfo
                                                    .tags
                                                    .contains(tag)) ||
                                                cardInfo.tags.isEmpty) &&
                                            (textFilter == null ||
                                                cardInfo.name
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(textFilter
                                                        .toLowerCase()));
                                      }).toList()
                                        ..sort((a, b) => a.name
                                            .toString()
                                            .compareTo(b.name.toString()));

                                      const double cardWidth = CARD_WIDTH * 1.1;
                                      final int crossAxisCount0 =
                                          (constraints.maxWidth - 40) /
                                              cardWidth ~/
                                              1;
                                      final int crossAxisCount =
                                          crossAxisCount0 < 1
                                              ? 1
                                              : crossAxisCount0;
                                      return SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 300.0,
                                          crossAxisCount: crossAxisCount,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            if (filteredCards[index].name ==
                                                CardName.INCITE) {
                                              logger.d(
                                                  'cardInfo: $filteredCards[index]');
                                            }
                                            return CardView(
                                              card: filteredCards[index],
                                              isSelected: false,
                                              isDeactivated: false,
                                            );
                                          },
                                          childCount: filteredCards.length,
                                        ),
                                      );
                                    });
                              });
                        });
                  })
            ]));
      });
    }

    return Center(
      child: FutureBuilder<Map<CardName, ClientCard>>(
        future: cardsF,
        builder: (BuildContext context,
            AsyncSnapshot<Map<CardName, ClientCard>> snapshot) {
          if (snapshot.hasData) {
            return getContentView(snapshot.data!);
          } else if (snapshot.hasError) {
            return Wrap(children: <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ]);
          } else {
            return Wrap(children: const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ]);
          }
        },
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
