import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game_models/ma_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_ma_info.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAward.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAwardMetadata.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/game_button_with_cost.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class MaView extends StatelessWidget {
  final double width;
  final double height;

  final PresentationMaInfo presentationInfo;

  final Color playerColor;
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
    required this.width,
    required this.height,
    required this.presentationInfo,
    required this.playerColor,
  });

  Widget _prepareMa(BuildContext context, MaModel ma) => Container(
        padding: EdgeInsets.only(
          left: 1.0,
          right: 1.0,
          top: 1.0,
        ),
        alignment: Alignment.center,
        width: width,
        height: height * 1.12,
        child: Tooltip(
          message: MilestoneAwardMetadata.allMilestoneAwards
              .firstWhere((m) => m.name == ma.name)
              .description,
          textStyle: TextStyle(fontSize: 16, color: Colors.white),
          waitDuration: Duration(milliseconds: 500),
          child: Column(children: [
            ...ma.name.toImagePath() == null
                ? []
                : [
                    FittedBox(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 4.0,
                              right: 4.0,
                              top: 4.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              color: (presentationInfo.availableMa
                                          ?.contains(ma.name) ??
                                      false)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Container(
                              width: width * 1.2,
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                boxShadow: List.filled(
                                  2,
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2,
                                  ),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.none,
                                  alignment: Alignment(0.0, -0.6),
                                  image: AssetImage(
                                    ma.name.toImagePath()!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.0),
                            child: Text(
                              ma.name.toString().toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
            ...[
              Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ma.scores
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.0),
                            child: Container(
                              width: width / 6 - 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3),
                                  ),
                                  color: e.playerColor.toColor(true)),
                              child: Text(
                                e.playerScore.toString(),
                                textAlign: TextAlign.center,
                                style: MAIN_TEXT_STYLE,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ))
            ]
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final maNotifiers =
        Map<MilestoneAwardName, ValueNotifier<bool>>.fromIterable(
      presentationInfo.ma,
      key: (e) => e.name,
      value: (e) => ValueNotifier<bool>(false),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.black,
      ),
      child: Wrap(
        children: presentationInfo.ma.map(
          (e) {
            return ValueListenableBuilder(
              valueListenable: maNotifiers[e.name]!,
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
                              e.playerColor != null ||
                              presentationInfo.availableMa?.contains(e.name) !=
                                  true
                          ? null
                          : () {
                              final bool oldValue = maNotifiers[e.name]!.value;
                              maNotifiers
                                  .forEach((key, value) => value.value = false);
                              maNotifiers[e.name]!.value = !oldValue;
                            },
                      child: Stack(children: [
                        _prepareMa(context, e),
                        showButton || e.playerColor != null
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
                                    color: e.playerColor?.toColor(false) ??
                                        playerColor,
                                  ),
                                  child: showButton
                                      ? SizedBox.shrink()
                                      : CostView(
                                          cost:
                                              _getCostForActedMa(e.playerColor),
                                          width: 30,
                                          height: 30,
                                          fontSize: 30 * 0.65,
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
                                      .onConfirm!(e.name.toString()),
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
