import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/CardRequirementDescriptor.dart';
import 'package:mars_flutter/domain/model/card/RequirementType.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/politic_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/red_bordered_Image.dart';
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
        required bool isVenus,
      }) {
        Widget minusView = Text(
          '-',
          style: TextStyle(
            fontSize: height * 0.5,
            fontFamily: FontFamily.prototype,
          ),
        );
        List<Widget> multiplyReqView =
            (requirement.count ?? 0) > 3 || isTemp || isOxygen || isMax
                ? [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        child: Text(
                          (isMax ? "max" : "") +
                              requirement.count.toString() +
                              (isTemp ? "°C" : "") +
                              (isOxygen || isVenus ? "%" : ""),
                          style: TextStyle(
                            fontSize: height * 0.5,
                            fontFamily: FontFamily.prototype,
                          ),
                        )),
                    reqView
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
                              ),
                            ),
                            reqView
                          ]
                        : []),
                    ...Iterable<int>.generate(requirement.count ?? 1)
                        .map((_) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.5),
                            child: reqView))
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

      final imagePath = requirement.tag != null
          ? requirement.tag!.toImagePath()
          : requirement.production != null
              ? requirement.production!.toImagePath()
              : requirement.party != null
                  ? requirement.party!.toImagePath()
                  : requirement.requirementType.toImagePath();
      late final Widget view;
      switch (requirement.requirementType) {
        case RequirementType.PARTY_LEADERS:
          view = PoliticView(
            withRedBorder: requirement.all ?? false,
            imagePath: imagePath!,
          );
          break;
        case RequirementType.CHAIRMAN:
          view = PoliticView(
            withRedBorder: requirement.all ?? false,
            imagePath: imagePath!,
          );
          break;
        case RequirementType.REMOVED_PLANTS:
          view = RedBorderedImage(imagePath: imagePath!);
          break;
        default:
          view = requirement.all ?? false
              ? RedBorderedImage(imagePath: imagePath!)
              : Image(image: AssetImage(imagePath!));
      }
      return resPrepare(
        addMinus: requirement.requirementType == RequirementType.REMOVED_PLANTS,
        isProduction: requirement.requirementType == RequirementType.PRODUCTION,
        isTemp: requirement.requirementType == RequirementType.TEMPERATURE,
        isOxygen: requirement.requirementType == RequirementType.OXYGEN,
        isVenus: requirement.requirementType == RequirementType.VENUS,
        reqView: view,
      );
    }).toList();

    return requirements.length > 0
        ? Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                RequirementsBackground(
                  height: height * 0.75,
                  width: width * 0.7,
                  isMax: isMax,
                ),
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

class RequirementsBackground extends StatelessWidget {
  final double height;
  final double width;
  final bool isMax;
  const RequirementsBackground(
      {super.key,
      required this.height,
      required this.width,
      required this.isMax});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            blurRadius: 0.4,
            spreadRadius: 0.4,
          )
        ],
      ),
      child: Container(
        width: width,
        height: height,
      ),
    ));
  }
}
