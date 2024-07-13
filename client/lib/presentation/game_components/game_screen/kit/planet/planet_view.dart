import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/boards/SpaceBonus.dart';
import 'package:mars_flutter/domain/model/boards/SpaceType.dart';
import 'package:mars_flutter/domain/model/game_models/SpaceModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_planet_info.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/common/tile_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/planet/hexagone_builder.dart';

class MarsView extends StatefulWidget {
  final PresentationPlanetInfoCN planetInfoCN;
  const MarsView({required this.planetInfoCN});
  static const _marsSize = 500.0;
  static const _tileHeightSize = _marsSize * 0.092;

  @override
  State<MarsView> createState() => _MarsViewState();
}

class _BorderPainter extends CustomPainter {
  final Color? color;
  _BorderPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = color ?? Colors.transparent;
    Path path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.75)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(0, size.height * 0.75)
      ..lineTo(0, size.height * 0.25)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _MarsViewState extends State<MarsView> {
  double scale = 1.1;
  double top = 0.0;
  double left = 0.0;
  BoxConstraints oldConstrain = BoxConstraints();

  final double _sizeMultiplier = 1.4;

  Widget _prepareTileColorDecorator(
      SpaceModel spaceModel, bool showAvailableChoice) {
    Widget prepareHexBorderImage(Widget img) => !showAvailableChoice
        ? img
        : Stack(alignment: Alignment.center, children: [
            Padding(
              padding: EdgeInsets.all(3.0),
              child: img,
            ),
            CustomPaint(
              painter: _BorderPainter(
                  color: widget.planetInfoCN.activePlayer?.toColor(false)),
              child: SizedBox(
                width: MarsView._tileHeightSize * 1.4,
                height: MarsView._tileHeightSize * 1.4,
              ),
            )
          ]);
    return spaceModel.spaceType == SpaceType.OCEAN
        ? Container(
            color: Color.fromARGB(59, 68, 137, 255),
            child: prepareHexBorderImage(Image.asset(
              opacity: const AlwaysStoppedAnimation(.8),
              Assets.hexBlue.path,
            )))
        : prepareHexBorderImage(Image.asset(
            opacity: const AlwaysStoppedAnimation(.7),
            Assets.hexWhite.path,
          ));
  }

  Widget _prepareBonusView(SpaceModel spaceModel) {
    return Wrap(
      spacing: MarsView._marsSize * 0.01,
      children: spaceModel.bonus
          .map((SpaceBonus b) => ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
                maxWidth: MarsView._marsSize * 0.03,
                maxHeight: MarsView._marsSize * 0.05,
              ),
              child: b.toImagePath() == null
                  ? SizedBox.shrink()
                  : Image.asset(b.toImagePath()!)))
          .toList(),
    );
  }

  Widget _preparePlayedTileView(SpaceModel spaceModel) {
    return spaceModel.tileType == null
        ? SizedBox.shrink()
        : Container(
            padding: EdgeInsets.all(spaceModel.color == null ? 0.0 : 4.0),
            color: spaceModel.color == null
                ? Colors.transparent
                : spaceModel.color!.toColor(true),
            child: TileView(
              tileType: spaceModel.tileType!,
              isAres: false,
              isCardTile: false,
              height: MarsView._tileHeightSize * 1.4,
              width: MarsView._tileHeightSize * 1.13,
            ),
          );
  }

  List<Widget> _prepareTilesOutsidePlanet(List<SpaceModel> spaceModels) {
    int tileOutsideMars = 0;
    final int outsideSpaceCount =
        PresentationPlanetInfoCN.spaceIdToText.entries.length;

    return PresentationPlanetInfoCN.spaceIdToText.entries
        .toList()
        .reversed
        .fold<List<Widget>>([], (acc, e) {
      final SpaceModel? spaceModel = spaceModels.fold<SpaceModel?>(
          null, (acc, spaceModel) => spaceModel.id == e.key ? spaceModel : acc);
      final bool planetStateContainCurrentSpase = spaceModel != null;

      if (planetStateContainCurrentSpase) {
        tileOutsideMars++;
        return [
          ...acc,
          Positioned(
              top: (MarsView._marsSize * _sizeMultiplier / 2 +
                      MarsView._marsSize *
                          _sizeMultiplier /
                          2 *
                          0.9 *
                          sin(2 * pi * tileOutsideMars / outsideSpaceCount) -
                      MarsView._tileHeightSize * _sizeMultiplier / 2) -
                  MarsView._tileHeightSize * 0.5,
              left: (MarsView._marsSize * _sizeMultiplier / 2 +
                  MarsView._marsSize *
                      _sizeMultiplier /
                      2 *
                      0.9 *
                      cos(2 * pi * tileOutsideMars / outsideSpaceCount) -
                  MarsView._tileHeightSize * _sizeMultiplier / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    e.value,
                    textAlign: TextAlign.center,
                    style: MAIN_TEXT_STYLE,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 9.0),
                    child: HexagonWidget(
                      height: MarsView._tileHeightSize,
                      inBounds: false,
                      color: Color.fromARGB(0, 255, 213, 0),
                      type: HexagonType.POINTY,
                      child: HexagonBuilder(
                        children: [
                          _prepareTileColorDecorator(spaceModel, false),
                          _prepareBonusView(spaceModel),
                          _preparePlayedTileView(spaceModel),
                        ],
                        useAnimation: false,
                        onClick: () =>
                            widget.planetInfoCN.onConfirm?.call(spaceModel.id),
                      ),
                    ),
                  ),
                ],
              )),
        ];
      } else {
        return acc;
      }
    }).toList();
  }

  late final Widget _marsView;
  @override
  void initState() {
    _marsView = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: MarsView._marsSize,
            maxHeight: MarsView._marsSize,
          ),
          child: Image.asset(
            Assets.board.marsHd.path,
          ),
        ),
        ListenableBuilder(
            listenable: widget.planetInfoCN,
            builder: (context, child) {
              final List<SpaceModel> spaceModels =
                  widget.planetInfoCN.spaceModels;
              final List<SpaceId>? availableSpaces =
                  widget.planetInfoCN.availableSpaces;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    children: [..._prepareTilesOutsidePlanet(spaceModels)],
                  ),
                  HexagonGrid.pointy(
                    depth: 4,
                    width: MarsView._marsSize * 0.98,
                    buildTile: (coordinates) {
                      final int serverCoordinateR = coordinates.r + 4;
                      final int serverCoordinateQ = coordinates.q +
                          4 +
                          (serverCoordinateR > 4 ? serverCoordinateR - 4 : 0);
                      final SpaceModel spaceModel = spaceModels.firstWhere(
                        (element) =>
                            element.x == serverCoordinateQ &&
                            element.y == serverCoordinateR,
                      );
                      final bool useAnimation = availableSpaces?.any((e) =>
                              e.id == spaceModel.id.id && e.id != null) ??
                          false;
                      return HexagonWidgetBuilder(
                        padding: 1.0,
                        color: Color.fromARGB(0, 255, 213, 0),
                        child: HexagonWidget(
                          height: MarsView._tileHeightSize,
                          inBounds: false,
                          color: Color.fromARGB(0, 255, 213, 0),
                          type: HexagonType.POINTY,
                          child: HexagonBuilder(
                            children: [
                              _prepareTileColorDecorator(
                                  spaceModel, useAnimation),
                              _prepareBonusView(spaceModel),
                              _preparePlayedTileView(spaceModel),
                            ],
                            useAnimation: useAnimation,
                            onClick: () => widget.planetInfoCN.onConfirm
                                ?.call(spaceModel.id),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            })
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double delay = 200.0;
    DateTime previousScaleTime = DateTime.now();
    DateTime previousMovementTime = DateTime.now();

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent &&
            DateTime.timestamp().difference(previousScaleTime).inMilliseconds >
                delay) {
          if (scale >= 1.0 && pointerSignal.scrollDelta.dy > 0 ||
              scale <= 2.0 && pointerSignal.scrollDelta.dy < 0)
            setState(() => scale += pointerSignal.scrollDelta.dy * 0.0005 * -1);
        }
      },
      onPointerMove: (event) {
        if (DateTime.timestamp()
                .difference(previousMovementTime)
                .inMilliseconds >
            delay)
          setState(() {
            top += event.delta.dy * 0.9;
            left += event.delta.dx * 0.9;
          });
      },
      child: AnimatedScale(
        curve: Curves.fastEaseInToSlowEaseOut,
        duration: Duration(milliseconds: 2300),
        scale: scale,
        child: LayoutBuilder(
          builder: (context, constrain) {
            if (oldConstrain.maxHeight != constrain.maxHeight ||
                oldConstrain.maxWidth != constrain.maxWidth) {
              oldConstrain = constrain;
              top = constrain.maxHeight / 2 -
                  MarsView._marsSize * _sizeMultiplier / 2;
              left = constrain.maxWidth / 2 -
                  MarsView._marsSize * _sizeMultiplier / 2;
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                ),
                AnimatedPositioned(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  top: top,
                  left: left,
                  width: MarsView._marsSize * _sizeMultiplier,
                  height: MarsView._marsSize * _sizeMultiplier,
                  duration: Duration(milliseconds: 3000),
                  child: _marsView,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
