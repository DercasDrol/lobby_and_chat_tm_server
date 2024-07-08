import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/production_box.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class PlayerResourceView extends StatelessWidget {
  final double width;
  final double height;
  final int productionCount;
  final int resourceCount;
  final int? cost;
  final bool? showCountInsideIcon;
  final Widget icon;
  final bool useRightArrow;

  const PlayerResourceView({
    required this.width,
    required this.height,
    required this.productionCount,
    required this.resourceCount,
    required this.icon,
    required this.useRightArrow,
    this.cost,
    this.showCountInsideIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Color.fromARGB(117, 0, 0, 0),
      ),
      child: Stack(children: [
        Column(
          children: [
            Expanded(
              flex: 12,
              child: ProductionBox(
                child: Container(
                    width: width,
                    height: height,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.5),
                            child: icon,
                          ),
                          FittedBox(
                              child: Text(productionCount.toString(),
                                  style: MAIN_TEXT_STYLE))
                        ])),
                padding: 0.0,
                innerPadding: 0.0,
              ),
            ),
            Expanded(
                flex: 12,
                child: FittedBox(
                    child: Text(resourceCount.toString(),
                        style: MAIN_TEXT_STYLE))),
          ],
        ),
        if (cost != null)
          CostView(
            cost: cost!,
            width: height * 0.3,
            height: height * 0.3,
            multiplier: false,
            useGreyMode: false,
            useShadow: true,
          ),
      ]),
    );
  }
}
