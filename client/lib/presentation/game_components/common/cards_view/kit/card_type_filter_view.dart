import 'package:flutter/material.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/kit/chip_box.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/kit/invert_button.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class CardTypeFilterView extends StatelessWidget {
  final ValueNotifier<List<CardType>> selectedCardTypesN;
  final List<CardType> targetTypes;
  const CardTypeFilterView(
      {super.key, required this.selectedCardTypesN, required this.targetTypes});

  @override
  Widget build(BuildContext context) {
    final allValues = targetTypes
        .where((element) =>
            ![CardType.PROXY, CardType.STANDARD_ACTION].contains(element))
        .toList();
    return Wrap(children: [
      InvertButton<CardType>(
        selected: selectedCardTypesN,
        all: allValues,
        onInverted: (inverted) {
          logger.d(inverted);
          selectedCardTypesN.value = inverted;
        },
      ),
      ...allValues
          .map((cardType) => ValueListenableBuilder(
                valueListenable: selectedCardTypesN,
                builder: (context, selectedCardTypes, child) {
                  return ChipBox(
                    labelSymbolCount: cardType.toString().length,
                    useImage: false,
                    child: GameOptionView(
                      useBigberSize: true,
                      lablePart1: cardType.toString(),
                      type: GameOptionType.TOGGLE_BUTTON,
                      isSelected: selectedCardTypes.contains(cardType),
                      onDropdownOptionChangedOrOptionToggled: (_) {
                        if (!selectedCardTypes.contains(cardType)) {
                          selectedCardTypesN.value = [
                            ...selectedCardTypes,
                            cardType
                          ];
                        } else {
                          selectedCardTypesN.value = selectedCardTypes
                              .where((t) => t != cardType)
                              .toList();
                        }
                      },
                    ),
                  );
                },
              ))
          .toList(),
    ]);
  }
}
