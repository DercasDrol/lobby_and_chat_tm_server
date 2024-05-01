import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';
import 'package:mars_flutter/domain/model/card/render/ICardRenderVictoryPoints.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/red_bordered_Image.dart';

class VpointsView extends StatelessWidget {
  final double height;
  final double width;
  final ICardRenderVictoryPoints points;
  final bool isCardPoints;

  const VpointsView({
    required this.width,
    required this.height,
    required this.points,
    required this.isCardPoints,
  });

  @override
  Widget build(BuildContext context) {
    final Widget vpoints;
    final itemWidth = width * 0.35;
    getImageView() {
      final imagePath = (points as ICardRenderDynamicVictoryPoints)
          .item!
          .type
          .toImagePath(false)!;
      return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: itemWidth,
            maxHeight: height * 0.9,
          ),
          child: (points as ICardRenderDynamicVictoryPoints).item!.anyPlayer ??
                  false
              ? RedBorderedImage(imagePath: imagePath)
              : Image(
                  image: AssetImage(imagePath),
                ));
    }

    switch (points.runtimeType) {
      case ICardRenderStaticVictoryPoints:
        vpoints = Text(
          isCardPoints ? points.points.toString() : "VP",
          style: TextStyle(
            fontSize: height * 0.64,
            fontFamily: FontFamily.prototype,
            color: Colors.black,
          ),
        );
        break;
      case ICardRenderDynamicVictoryPoints:
        vpoints = ((points as ICardRenderDynamicVictoryPoints).target == 0 &&
                    points.points == 0) ||
                (points.points == -1 &&
                    (points as ICardRenderDynamicVictoryPoints).target == -1)
            ? Text(
                points.points == -1 ? "-1" : "?",
                style: TextStyle(
                  fontSize: height * 0.64,
                  fontFamily: FontFamily.prototype,
                  color: Colors.black,
                ),
              )
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ...[
                  Text(
                    points.points.toString() +
                        "/" +
                        ((points as ICardRenderDynamicVictoryPoints).target ==
                                    1 ||
                                points.points > 1
                            ? ''
                            : (points as ICardRenderDynamicVictoryPoints)
                                .target
                                .toString()),
                    style: TextStyle(
                      fontSize: height * 0.64,
                      fontFamily: FontFamily.prototype,
                      color: Colors.black,
                    ),
                  )
                ],
                ...((points as ICardRenderDynamicVictoryPoints).item == null
                    ? []
                    : [getImageView()])
              ]);
        break;
      default:
        throw Exception("Unknown victory points type");
    }
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width,
          minHeight: height,
          maxWidth: width,
          maxHeight: height,
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 168, 129, 0),
                      Color.fromARGB(255, 153, 92, 0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(width * 0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0),
                      offset: Offset(0.0, 0.0),
                      blurRadius: 1,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Container(
                  width: width,
                  height: height,
                  alignment: Alignment.center,
                  child: vpoints,
                ))));
  }
}
