import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/amounts_notifier.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/common/amount_changer_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/common/amount_presentation_info.dart';

class TabWithAmounts extends StatelessWidget {
  final AmountsNotifier amounts;

  TabWithAmounts({required this.amounts});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox.expand(
        child: ListenableBuilder(
          listenable: amounts,
          builder: (context, widget) => Column(
            mainAxisSize: MainAxisSize.min,
            children: amounts.amounts.entries.map(
              (amountEntire) {
                return AmountChangerView(
                  presentationInfo: AmountPresentationInfo(
                    onDecreaseButtonFn: () => amountEntire.value.value =
                        max(amountEntire.key.min, amountEntire.value.value - 1),
                    onIncreaseButtonFn: () => amountEntire.value.value =
                        min(amountEntire.key.max, amountEntire.value.value + 1),
                    onMaxButtonFn: () =>
                        amountEntire.value.value = amountEntire.key.max,
                    iconPath: amountEntire.key.toImagePath(),
                    value: amountEntire.value.value,
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
