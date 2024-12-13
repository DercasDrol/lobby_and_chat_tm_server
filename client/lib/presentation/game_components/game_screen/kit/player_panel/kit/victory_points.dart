import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/render/ICardRenderVictoryPoints.dart';
import 'package:mars_flutter/domain/model/game/IVictoryPointsBreakdown.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/common/vpoints.dart';

class VictoryPointsView extends StatelessWidget {
  final double width;
  final double height;
  final IVictoryPointsBreakdown victoryPoints;

  const VictoryPointsView({
    super.key,
    required this.width,
    required this.height,
    required this.victoryPoints,
  });

  _prepareButtonView(BuildContext context) => Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(left: 1.0, top: 1.0, right: 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Color.fromARGB(117, 0, 0, 0),
        ),
        child: Column(children: [
          Flexible(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.only(left: 1.0, top: 1.0, right: 1.0),
                child: VpointsView(
                  width: width,
                  height: height * 8 / (6 + 8),
                  points: ICardRenderStaticVictoryPoints(
                      points: victoryPoints.total),
                  isCardPoints: false,
                ),
              )),
          Flexible(
              flex: 6,
              child: Text(
                victoryPoints.total.toString(),
                style: MAIN_TEXT_STYLE,
              )),
        ]),
      );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.0, left: 10.0, bottom: 2.0),
      child: Tooltip(
        message: "Awards: " +
            victoryPoints.awards.toString() +
            "\nCities: " +
            victoryPoints.city.toString() +
            "\nCards: " +
            victoryPoints.victoryPoints.toString() +
            "\nTerraform Rating: " +
            victoryPoints.terraformRating.toString() +
            "\nGreenery: " +
            victoryPoints.greenery.toString() +
            "\nMilestones: " +
            victoryPoints.milestones.toString() +
            "\nTotal: " +
            victoryPoints.total.toString(),
        textAlign: TextAlign.end,
        textStyle: MAIN_TEXT_STYLE.copyWith(fontSize: 16),
        waitDuration: Duration(milliseconds: 300),
        child: _prepareButtonView(context),
      ),
    );
  }
}
