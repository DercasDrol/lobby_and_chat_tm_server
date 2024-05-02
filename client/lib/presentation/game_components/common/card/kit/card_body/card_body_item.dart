import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';
import 'package:mars_flutter/domain/model/card/render/Size.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/empty_tag_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/politic_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/secondary_tag_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/utils.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_requirements.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/red_bordered_Image.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/vpoints.dart';

class BodyItemView extends StatelessWidget {
  const BodyItemView({
    required this.item,
    required this.height,
    required this.width,
    required this.parentWidth,
  });
  final ICardRenderItem item;
  final double height;
  final double width;
  final double parentWidth;
  Widget _applyRedBorderForImage(String imagePath,
      {bool? invertColor = false}) {
    return item.anyPlayer ?? false
        ? RedBorderedImage(imagePath: imagePath)
        : ColorFiltered(
            colorFilter: invertColor == true
                ? const ColorFilter.matrix(<double>[
                    -1.0, 0.0, 0.0, 0.0, 255.0, //
                    0.0, -1.0, 0.0, 0.0, 255.0, //
                    0.0, 0.0, -1.0, 0.0, 255.0, //
                    0.0, 0.0, 0.0, 1.0, 0.0, //
                  ])
                : const ColorFilter.matrix(<double>[
                    1.0, 0.0, 0.0, 0.0, 0.0, //
                    0.0, 1.0, 0.0, 0.0, 0.0, //
                    0.0, 0.0, 1.0, 0.0, 0.0, //
                    0.0, 0.0, 0.0, 1.0, 0.0, //
                  ]),
            child: Image(image: AssetImage(imagePath)),
          );
  }

  Widget _applyPadding(
      {required Widget child,
      double? widthMultiplier,
      double? heightMultiplier}) {
    final itemWidth =
        width * item.size.toMultiplier() * (widthMultiplier ?? 1.0);
    final itemHeight =
        height * item.size.toMultiplier() * (heightMultiplier ?? 1.0);
    return Padding(
      padding: item.secondaryTag != null
          ? EdgeInsets.only(left: 1, bottom: 1, right: 4, top: 4)
          : EdgeInsets.all(1),
      child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: itemWidth,
            maxHeight: itemHeight,
          ),
          child: child),
    );
  }

  Widget _prepareImageView(String imagePath, {bool? invertColor = false}) =>
      Stack(
        alignment: Alignment.center,
        children: [
          _applyRedBorderForImage(imagePath, invertColor: invertColor),
          item.cancelled == true
              ? CrossView(
                  size: width * item.size.toMultiplier(),
                  color: Colors.black.withOpacity(0.6),
                  strokeWidth: 4.0,
                )
              : SizedBox.shrink(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    double itemWidthMultiplyer;
    switch (item.type) {
      case CardRenderItemType.VENUS:
        itemWidthMultiplyer = 1.5;
        break;
      case CardRenderItemType.TR:
        itemWidthMultiplyer = 1.5;
        break;
      case CardRenderItemType.OXYGEN:
        itemWidthMultiplyer = 1.4;
        break;
      case CardRenderItemType.TEMPERATURE:
        itemWidthMultiplyer = 0.7;
        break;
      case CardRenderItemType.TRADE_FLEET:
        itemWidthMultiplyer = 1.5;
        break;
      case CardRenderItemType.TRADE:
        itemWidthMultiplyer = 1.0;
        break;
      default:
        itemWidthMultiplyer =
            item.type.toItemShape(false) == ItemShape.hexagon ? 1.4 : 1.0;
        break;
    }
    final String? imagePath =
        item.type.toImagePath(item.isPlayed == null ? false : item.isPlayed!);

    Widget createGeneralTile(
        {double? widthMult, double? heightMult, Widget? child}) {
      return (item.amount.abs() > 1 && item.showDigit == true)
          ? Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                  BodyItemCover(
                    text: item.amount.abs().toString(),
                    height: height * item.size.toMultiplier() * 0.8,
                    width: width * item.size.toMultiplier() * 0.4,
                    parentHeight: height,
                  ),
                  _applyPadding(
                    child: child ?? _prepareImageView(imagePath!),
                    widthMultiplier: widthMult ?? itemWidthMultiplyer,
                    heightMultiplier: heightMult ?? itemWidthMultiplyer,
                  ),
                ])
          : _applyPadding(
              child: child ?? _prepareImageView(imagePath!),
              widthMultiplier: widthMult ?? itemWidthMultiplyer,
              heightMultiplier: heightMult ?? itemWidthMultiplyer,
            );
    }

    Widget createItem() {
      switch (item.type) {
        case CardRenderItemType.MEGACREDITS:
          return createGeneralTile(
            child: CostView(
              height: width * item.size.toMultiplier(),
              width: height * item.size.toMultiplier(),
              fontSize: height * item.size.toMultiplier() * 0.56,
              cost: item.amount,
              text: item.innerText,
              multiplier: false,
              useGreyMode: false,
              showRedBoarder: item.anyPlayer,
            ),
          );
        case CardRenderItemType.TEMPERATURE:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 1.0,
            heightMult: 1.5,
          );
        case CardRenderItemType.CARDS:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 0.9,
            heightMult: 1.6,
          );
        case CardRenderItemType.RULING_PARTY:
          return _applyPadding(
            child: _prepareImageView(imagePath!),
            widthMultiplier: 1.7,
            heightMultiplier: 1.3,
          );
        case CardRenderItemType.INFLUENCE:
          return _applyPadding(
            child: _prepareImageView(imagePath!),
            widthMultiplier: 1.2,
            heightMultiplier: 1.2,
          );
        case CardRenderItemType.EXCAVATE:
          return _applyPadding(
            child: _prepareImageView(imagePath!),
            widthMultiplier: 1.35,
            heightMultiplier: 1.35,
          );
        case CardRenderItemType.VENUS:
          return _applyPadding(
            child: _prepareImageView(imagePath!),
            widthMultiplier: 2.0,
            heightMultiplier: 1.0,
          );
        case CardRenderItemType.TEXT:
          return item.text == null || item.text == ""
              ? SizedBox.shrink()
              : Text(
                  item.isUppercase == true
                      ? item.text!.toUpperCase()
                      : item.text!,
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: TextStyle(
                    fontSize: height * item.size.toMultiplier() * 0.5,
                    height: 1.0,
                    fontFamily: FontFamily.prototype,
                    color: Colors.black,
                    fontWeight: item.isBold == true
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                );
        case CardRenderItemType.PLATE:
          return Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 255, 196, 0),
                      Colors.yellow,
                      Color.fromARGB(255, 255, 196, 0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0),
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3,
                      spreadRadius: 0.5,
                    )
                  ],
                ),
                width: min(
                    (item.text == null ? "" : item.text!.toUpperCase()).length *
                        7.5 *
                        item.size.toMultiplier(),
                    parentWidth * 0.5),
                height: height * item.size.toMultiplier() * 1.2,
                alignment: Alignment.center,
                child: Text(
                  item.text == null ? "" : item.text!.toUpperCase(),
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: TextStyle(
                    fontSize: height * item.size.toMultiplier() * 0.45,
                    height: 1.0,
                    fontFamily: FontFamily.prototype,
                    color: Colors.black,
                    fontWeight: item.isBold == true
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ));
        case CardRenderItemType.TRADE_FLEET:
          return _applyPadding(
            child: _prepareImageView(imagePath!, invertColor: true),
            widthMultiplier: itemWidthMultiplyer,
            heightMultiplier: 1.0,
          );
        case CardRenderItemType.REDS_DEACTIVATED:
          //сделать картинку черно-белой
          return _applyPadding(child: _prepareImageView(imagePath!));
        case CardRenderItemType.TRADE_DISCOUNT:
          return _applyPadding(
            child: BodyItemCover(
              text: item.text,
              height: height * item.size.toMultiplier() * 0.4,
              width: width * item.size.toMultiplier(),
              parentHeight: height,
            ),
          );
        case CardRenderItemType.COMMUNITY:
          return _applyPadding(
            child: Container(
              width: width * item.size.toMultiplier(),
              height: height * item.size.toMultiplier(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange,
                    Color.fromARGB(255, 255, 81, 0),
                  ],
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
            ),
          );
        case CardRenderItemType.NO_TAGS:
          return _applyPadding(
              child: Stack(alignment: Alignment.center, children: [
            EmptyTagView(
              width: width * item.size.toMultiplier(),
              height: height * item.size.toMultiplier(),
            ),
            CrossView(
              size: width * item.size.toMultiplier(),
              color: Colors.black,
              strokeWidth: 4.0,
            ),
          ]));
        case CardRenderItemType.EMPTY_TAG:
          return _applyPadding(
            child: EmptyTagView(
              width: width * item.size.toMultiplier(),
              height: height * item.size.toMultiplier(),
            ),
          );
        case CardRenderItemType.DIVERSE_TAG:
          return Container(
            width: width * item.size.toMultiplier(),
            height: height * item.size.toMultiplier(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                ],
              ),
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
            ),
          );
        case CardRenderItemType.PRELUDE:
          return Container(
            width: width * item.size.toMultiplier() * 1.8,
            height: height * item.size.toMultiplier() * 0.8,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Colors.grey.shade700,
                  Colors.grey.shade500,
                  Colors.grey.shade700,
                  Colors.grey.shade800,
                  Colors.black,
                ],
              ),
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: CardType.PRELUDE.toColor(),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Center(
                child: Text(
                  "PREL",
                  style: TextStyle(
                    fontSize: height * item.size.toMultiplier() * 0.4,
                    fontFamily: FontFamily.prototype,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          );
        case CardRenderItemType.COLONY_TILE:
          return Container(
            margin: EdgeInsets.only(left: width * 0.2),
            width: width * 3 * item.size.toMultiplier(),
            height: height * item.size.toMultiplier(),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                "COLONY",
                style: TextStyle(
                  fontSize: height * item.size.toMultiplier() * 0.6,
                  fontFamily: FontFamily.prototype,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ),
          );
        case CardRenderItemType.IGNORE_GLOBAL_REQUIREMENTS:
          return Container(
              margin: EdgeInsets.all(3.0),
              width: width * item.size.toMultiplier() * 5,
              height: height * item.size.toMultiplier(),
              child: Stack(alignment: Alignment.center, children: [
                RequirementsBackground(
                  height: height * item.size.toMultiplier(),
                  width: width * item.size.toMultiplier() * 5,
                  isMax: false,
                ),
                Text(
                  "Global Requirements",
                  style: TextStyle(
                    fontSize: height * item.size.toMultiplier() * 0.5,
                    fontFamily: FontFamily.prototype,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
                CrossView(
                  size: width * item.size.toMultiplier(),
                  color: Colors.black,
                  strokeWidth: 5.0,
                ),
              ]));
        case CardRenderItemType.AWARD:
          return Container(
            margin: EdgeInsets.all(3.0),
            width: width * 2,
            height: height * 0.7,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                "AWARD",
                style: TextStyle(
                  fontSize: height * 0.4,
                  fontFamily: FontFamily.prototype,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
            ),
          );
        case CardRenderItemType.MILESTONE:
          //нарисовать оранжевый прямоугольник с черным текстом внутри "MILESTONE"
          return SizedBox.shrink();
        case CardRenderItemType.PLACE_COLONY:
          //нарисовать черный овал с белым текстом внутри "COLONY"
          return SizedBox.shrink();
        case CardRenderItemType.SELF_REPLICATING:
          //взять картинку карты и поверх нее нарисовать цифру 2 в круге и 2 тэга сверху (билдинг и космос)
          return SizedBox.shrink();
        case CardRenderItemType.PARTY_LEADERS:
          return createGeneralTile(
            child: PoliticView(
              withRedBorder: item.anyPlayer ?? false,
              imagePath: imagePath!,
            ),
          );
        case CardRenderItemType.VP:
          return VpointsView(
            height: height * item.size.toMultiplier(),
            width: width * item.size.toMultiplier(),
            isCardPoints: true,
            text: "?",
          );
        case CardRenderItemType.MULTIPLIER_WHITE:
          //отрисовать белый квадрат с черным Х внутри
          return SizedBox.shrink();
        case CardRenderItemType.NOMADS:
          return Container(
            width: width * item.size.toMultiplier(),
            height: height * item.size.toMultiplier(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 255, 196, 0),
                  Color.fromARGB(255, 255, 196, 0),
                  Colors.brown,
                  Color.fromARGB(255, 255, 196, 0),
                  Color.fromARGB(255, 255, 196, 0),
                ],
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3,
                  spreadRadius: 0.5,
                )
              ],
            ),
          );
        case CardRenderItemType.UNDERGROUND_SHELTERS:
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 4.0, right: 4.0),
                child: Image(
                  image: AssetImage(Assets.underworld.excavate.path),
                  width: width * item.size.toMultiplier(),
                  height: height * item.size.toMultiplier(),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.white, blurRadius: 2, spreadRadius: 0.5)
                    ]),
                    child: Image(
                      image: AssetImage(Assets.tiles.city.path),
                      width: width * item.size.toMultiplier() * 0.5,
                      height: height * item.size.toMultiplier() * 0.5,
                    )),
              ),
            ],
          );
        case CardRenderItemType.UNDERGROUND_RESOURCES:
          return Container(
            child: Stack(
              children: [
                _prepareImageView(
                    Assets.underworld.undergroundTokenBackground.path),
                item.cancelled == true
                    ? CrossView(
                        size: width * item.size.toMultiplier(),
                        color: Colors.black.withOpacity(0.6),
                        strokeWidth: 4.0,
                      )
                    : SizedBox.shrink(),
              ],
            ),
            width: width * item.size.toMultiplier(),
            height: height * item.size.toMultiplier(),
          );
        case CardRenderItemType.TR:
          return createGeneralTile(
            widthMult: item.size == CardItemSize.SMALL ? 1.7 : 1.5,
            heightMult: item.size == CardItemSize.SMALL ? 1.6 : 1.3,
          );
        case CardRenderItemType.CHAIRMAN:
          return createGeneralTile(
            child: PoliticView(
              withRedBorder: item.anyPlayer ?? false,
              imagePath: imagePath!,
            ),
          );
        default:
          return createGeneralTile();
      }
    }

    Widget addSecondaryTagIfNeeded(Widget child) {
      if (item.secondaryTag != null) {
        return Stack(
          children: [
            child,
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.white, blurRadius: 2, spreadRadius: 0.5)
                ]),
                child: SecondaryTagView(
                  secondaryTag: item.secondaryTag!,
                  width: width * item.size.toMultiplier() * 0.6,
                  height: height * item.size.toMultiplier() * 0.6,
                ),
              ),
            ),
          ],
        );
      } else {
        return child;
      }
    }

    final itemWidth = width * item.size.toMultiplier() * itemWidthMultiplyer;
    if (item.amount.abs() > 1 &&
        item.showDigit == false &&
        item.amountInside != true) {
      return Table(defaultColumnWidth: FixedColumnWidth(itemWidth), children: [
        TableRow(
          children: Iterable<int>.generate(item.amount.abs())
              .map((_) => addSecondaryTagIfNeeded(createItem()))
              .toList(),
        )
      ]);
    } else {
      return addSecondaryTagIfNeeded(createItem());
    }
  }
}
