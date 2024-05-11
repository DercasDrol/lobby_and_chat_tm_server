import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/kit/chip_box.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class InvertButton<T> extends StatelessWidget {
  final ValueNotifier<List<T>> selected;
  final List<T> all;
  final void Function(List<T>) onInverted;
  const InvertButton(
      {super.key,
      required this.selected,
      required this.all,
      required this.onInverted});

  @override
  Widget build(BuildContext context) {
    return ChipBox(
        labelSymbolCount: 6,
        useImage: false,
        child: GameOptionContainer(
            child: GameOptionView(
          useBigberSize: true,
          lablePart1: "Invert",
          type: GameOptionType.BUTTON,
          isSelected: true,
          onDropdownOptionChangedOrOptionToggled: (_) {
            onInverted(all.toSet().difference(selected.value.toSet()).toList());
          },
        )));
  }
}
