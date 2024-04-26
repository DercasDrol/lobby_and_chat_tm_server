import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/kit/chip_box.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/kit/invert_button.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class ModulesFilterView extends StatelessWidget {
  final ValueNotifier<List<GameModule>> selectedModulesN;
  const ModulesFilterView({super.key, required this.selectedModulesN});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      InvertButton<GameModule>(
        selected: selectedModulesN,
        all: GameModule.values,
        onInverted: (inverted) {
          selectedModulesN.value = inverted;
        },
      ),
      ...GameModule.values
          .map((module) => ValueListenableBuilder(
                valueListenable: selectedModulesN,
                builder: (context, selectedModules, child) {
                  return ChipBox(
                    labelSymbolCount: module.moduleName?.length ?? 0,
                    useImage: true,
                    child: GameOptionView(
                      useBigberSize: true,
                      image: module.toIconPath(),
                      lablePart1: module.moduleName,
                      type: GameOptionType.TOGGLE_BUTTON,
                      isSelected: selectedModules.contains(module),
                      onDropdownOptionChangedOrOptionToggled: (_) {
                        if (!selectedModules.contains(module)) {
                          selectedModulesN.value = [...selectedModules, module];
                        } else {
                          selectedModulesN.value = selectedModules
                              .where((t) => t != module)
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
