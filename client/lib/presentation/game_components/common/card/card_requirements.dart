import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/ICardRequirement.dart';
import 'package:mars_flutter/domain/model/card/RequirementType.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_utils.dart';
import 'package:mars_flutter/presentation/game_components/common/production_box.dart';

class CardRequirementsView extends StatelessWidget {
  final double height;
  final double width;
  final List<ICardRequirement> requirements;

  const CardRequirementsView({
    required this.width,
    required this.height,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMax = requirements.any((requirement) => requirement.isMax);
    List<Widget> requirementsViews = requirements.map((requirement) {
      Widget resPrepare({
        required bool addMinus,
        required bool isProduction,
        required bool isTemp,
        required Widget reqView,
        required bool isOxygen,
      }) {
        Widget minusView = Text(
          '-',
          style: TextStyle(
            fontSize: height * 0.5,
            fontFamily: FontFamily.prototype,
          ),
        );
        final reqViewWithRedBox =
            requirement.type.toItemShape() != null && requirement.isAny
                ? RedItemBox(
                    child: reqView,
                    width: height,
                    shape: requirement.type.toItemShape()!,
                  )
                : reqView;
        List<Widget> multiplyReqView =
            requirement.amount > 3 || isTemp || isOxygen
                ? [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        child: Text(
                          (isMax ? "max" : "") +
                              requirement.amount.toString() +
                              (isTemp ? "°C" : "") +
                              (isOxygen ? "%" : ""),
                          style: TextStyle(
                            fontSize: height * 0.5,
                            fontFamily: FontFamily.prototype,
                          ),
                        )),
                    reqViewWithRedBox
                  ]
                : [
                    ...(isMax
                        ? [
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.0),
                                child: Text(
                                  "max",
                                  style: TextStyle(
                                    fontSize: height * 0.5,
                                    fontFamily: FontFamily.prototype,
                                  ),
                                ))
                          ]
                        : []),
                    ...Iterable<int>.generate(requirement.amount)
                        .map((_) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.5),
                            child: reqViewWithRedBox))
                        .toList()
                  ];
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ...(addMinus ? [minusView] : []),
          ...(isProduction
              ? [
                  ProductionBox(
                    padding: 0.0,
                    innerPadding: 3.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: multiplyReqView),
                  )
                ]
              : multiplyReqView),
        ]);
      }

      return resPrepare(
          addMinus: requirement.type == RequirementType.REMOVED_PLANTS,
          isProduction: requirement.type == RequirementType.PRODUCTION,
          isTemp: requirement.type == RequirementType.TEMPERATURE,
          isOxygen: requirement.type == RequirementType.OXYGEN,
          reqView: Image(
            image: AssetImage(
              requirement.runtimeType == ITagCardRequirement
                  ? (requirement as ITagCardRequirement).tag.toImagePath()!
                  : requirement.runtimeType == IProductionCardRequirement
                      ? (requirement as IProductionCardRequirement)
                          .resource
                          .toImagePath()!
                      : requirement.runtimeType == IPartyCardRequirement
                          ? (requirement as IPartyCardRequirement)
                              .party
                              .toImagePath()!
                          : requirement.type.toImagePath()!,
            ),
          ));
    }).toList();

    return requirements.length > 0
        ? Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                Center(
                    child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: isMax
                          ? [
                              Colors.red[700]!,
                              Color.fromARGB(255, 255, 196, 0),
                              Colors.red[700]!,
                            ]
                          : [
                              Color.fromARGB(255, 255, 196, 0),
                              Colors.yellow,
                              Color.fromARGB(255, 255, 196, 0),
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.2,
                        spreadRadius: 0.2,
                      )
                    ],
                  ),
                  child: Container(
                    width: width * 0.7,
                    height: height * 0.75,
                  ),
                )),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: requirementsViews,
                )),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
