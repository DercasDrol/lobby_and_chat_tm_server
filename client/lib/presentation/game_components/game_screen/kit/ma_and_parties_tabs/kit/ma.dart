import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game_models/ma_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_ma_info.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAward.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/game_button_with_cost.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/common/ma_and_party_tile.dart';

class MaView extends StatelessWidget {
  final double elementWidth;
  final double elementHeight;
  final double width;

  final PresentationMaInfo presentationInfo;

  final PlayerColor playerColor;
  int get _cost => presentationInfo.ma
          .any((element) => element.runtimeType == ClaimedMilestoneModel)
      ? PresentationMaInfo.milestoneCost
      : PresentationMaInfo.awardsCost[presentationInfo.ma.fold(
          0,
          (previousValue, element) =>
              element.playerColor != null ? previousValue + 1 : previousValue,
        )];
  int _getCostForActedMa(PlayerColor? pColor) {
    final int index = pColor == null
        ? -1
        : presentationInfo.playerAwardsOrder?.indexOf(pColor) ?? -1;
    return index != -1 ? PresentationMaInfo.awardsCost[index] : _cost;
  }

  const MaView({
    super.key,
    required this.elementWidth,
    required this.elementHeight,
    required this.presentationInfo,
    required this.playerColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final maNotifiers =
        Map<MilestoneAwardName, ValueNotifier<bool>>.fromIterable(
      presentationInfo.ma,
      key: (ma) => ma.name,
      value: (e) => ValueNotifier<bool>(false),
    );
    return Container(
      width: width,
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.black,
      ),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: presentationInfo.ma.map(
          (ma) {
            return ValueListenableBuilder(
              valueListenable: maNotifiers[ma.name]!,
              builder: (context, showButton, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: presentationInfo.onConfirm == null ||
                              ma.playerColor != null ||
                              presentationInfo.availableMa?.contains(ma.name) !=
                                  true
                          ? null
                          : () {
                              final bool oldValue = maNotifiers[ma.name]!.value;
                              maNotifiers
                                  .forEach((key, value) => value.value = false);
                              maNotifiers[ma.name]!.value = !oldValue;
                            },
                      child: Stack(children: [
                        MaAndPartyTile(
                          ma: ma,
                          isAvailableForClick:
                              presentationInfo.availableMa?.contains(ma.name),
                          height: elementHeight,
                          width: elementWidth,
                        ),
                        showButton || ma.playerColor != null
                            ? Padding(
                                padding: EdgeInsets.only(top: 7.0, left: 7.0),
                                child: Container(
                                  padding: EdgeInsets.all(3.0),
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    boxShadow: List.filled(
                                      2,
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: ma.playerColor?.toColor(false) ??
                                        playerColor.toColor(false),
                                  ),
                                  child: showButton
                                      ? SizedBox.shrink()
                                      : CostView(
                                          cost: _getCostForActedMa(
                                              ma.playerColor),
                                          width: 30,
                                          height: 30,
                                          multiplier: false,
                                          useGreyMode: false,
                                        ),
                                ),
                              )
                            : SizedBox.shrink()
                      ]),
                    ),
                    showButton
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 3.0),
                            child: GameButtonWithCost(
                              counter: _cost,
                              onPressed: presentationInfo.onConfirm == null
                                  ? null
                                  : () => presentationInfo
                                      .onConfirm!(ma.name.toString()),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ))
                        : SizedBox.shrink()
                  ],
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
