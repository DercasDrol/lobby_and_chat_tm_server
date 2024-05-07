import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/filters_options_view/kit/filter_item_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/filters_options_view/kit/single_batch_selector.dart';

class CorporationsFilterView extends StatelessWidget {
  final Set<ClientCard> corporations;
  final ValueNotifier<Set<ClientCard>> selectedCorporationsN;
  const CorporationsFilterView({
    super.key,
    required this.corporations,
    required this.selectedCorporationsN,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Wrap(
          children: GameModule.values.map((gameModule) {
            final corps = corporations
                .where((corporation) => corporation.module == gameModule)
                .toSet();
            return corps.isEmpty
                ? SizedBox.shrink()
                : Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: SingleBatchSelector<ClientCard>(
                      items: corporations
                          .where(
                              (corporation) => corporation.module == gameModule)
                          .toSet(),
                      selectedItemsN: selectedCorporationsN,
                      itemBuilder: (corporation) => FilterItemView(
                        text: corporation.name.toString(),
                        images: corporation.compatibility
                            .map((e) => e.toIconPath() ?? "undefined")
                            .toList(),
                      ),
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
