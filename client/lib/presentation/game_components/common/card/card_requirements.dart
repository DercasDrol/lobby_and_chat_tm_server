import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/CardRequirementDescriptor.dart';

import 'package:mars_flutter/domain/model/card/RequirementType.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_utils.dart';
import 'package:mars_flutter/presentation/game_components/common/production_box.dart';

class CardRequirementsView extends StatelessWidget {
  final double height;
  final double width;
  final List<CardRequirementDescriptor> requirements;

  const CardRequirementsView({
    required this.width,
    required this.height,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMax =
        requirements.any((requirement) => requirement.max ?? false);
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
            requirement.requirementType.toItemShape() != null &&
                    (requirement.all ?? false)
                ? RedItemBox(
                    child: reqView,
                    width: height,
                    shape: requirement.requirementType.toItemShape()!,
                  )
                : reqView;
        List<Widget> multiplyReqView =
            (requirement.count ?? 0) > 3 || isTemp || isOxygen
                ? [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        child: Text(
                          (isMax ? "max" : "") +
                              requirement.count.toString() +
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
                    ...Iterable<int>.generate(requirement.count ?? 0)
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
          addMinus:
              requirement.requirementType == RequirementType.REMOVED_PLANTS,
          isProduction:
              requirement.requirementType == RequirementType.PRODUCTION,
          isTemp: requirement.requirementType == RequirementType.TEMPERATURE,
          isOxygen: requirement.requirementType == RequirementType.OXYGEN,
          reqView: Image(
            image: AssetImage(
              requirement.tag != null
                  ? requirement.tag!.toImagePath()!
                  : requirement.production != null
                      ? requirement.production!.toImagePath()!
                      : requirement.party != null
                          ? requirement.party!.toImagePath()!
                          : requirement.requirementType.toImagePath()!,
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
