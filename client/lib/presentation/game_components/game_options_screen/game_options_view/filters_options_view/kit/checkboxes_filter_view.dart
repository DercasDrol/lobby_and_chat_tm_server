import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/presentation/game_components/common/card_tooltip.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/filters_options_view/kit/common/filter_item_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/filters_options_view/kit/common/single_batch_selector.dart';

class CheckboxesFilterView<T> extends StatelessWidget {
  final Set<T> elements;
  final ValueNotifier<Set<T>> selectedElementsN;
  final GameModule Function(T element) getGameModule;
  final String Function(T element) getName;
  final List<String> Function(T element)? getImagePaths;
  const CheckboxesFilterView({
    super.key,
    required this.elements,
    required this.selectedElementsN,
    required this.getGameModule,
    required this.getName,
    this.getImagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Wrap(
          children: GameModule.values.map((gameModule) {
            final moduleElements = elements
                .where((element) => getGameModule(element) == gameModule)
                .toSet();
            return moduleElements.isEmpty
                ? SizedBox.shrink()
                : Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: SingleBatchSelector<T>(
                      items: elements
                          .where(
                              (element) => getGameModule(element) == gameModule)
                          .toSet(),
                      selectedItemsN: selectedElementsN,
                      itemBuilder: (element) {
                        final view = FilterItemView(
                          text: getName(element),
                          images: getImagePaths != null
                              ? getImagePaths!(element)
                              : [],
                        );
                        return element.runtimeType == ClientCard
                            ? CardTooltip(
                                cardName: (element as ClientCard).name,
                                child: view,
                                sizeMultiplier: 1.1,
                              )
                            : view;
                      },
                      batchTitle: FilterItemView(
                        text: gameModule.moduleName ?? " ",
                        images: gameModule.toIconPath() != null
                            ? [gameModule.toIconPath()!]
                            : [],
                      ),
                    ),
                  );
          }).toList(),
        ),
      ),
    );
  }
}
