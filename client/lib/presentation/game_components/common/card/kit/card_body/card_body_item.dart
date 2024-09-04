import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';
import 'package:mars_flutter/domain/model/card/render/Size.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/empty_tag_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/politic_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/secondary_tag_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/utils.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_requirements.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_tag.dart';
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
      {bool invertColor = false,
      bool greyColor = false,
      bool darkMode = false}) {
    final coloredImage = ColorFiltered(
      colorFilter: invertColor == true
          ? const ColorFilter.matrix(<double>[
              -1.0, 0.0, 0.0, 0.0, 255.0, //
              0.0, -1.0, 0.0, 0.0, 255.0, //
              0.0, 0.0, -1.0, 0.0, 255.0, //
              0.0, 0.0, 0.0, 1.0, 0.0, //
            ])
          : greyColor
              ? const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0, //
                  0.2126, 0.7152, 0.0722, 0, 0, //
                  0.2126, 0.7152, 0.0722, 0, 0, //
                  0, 0, 0, 1, 0, //
                ])
              : const ColorFilter.matrix(<double>[
                  1.0, 0.0, 0.0, 0.0, 0.0, //
                  0.0, 1.0, 0.0, 0.0, 0.0, //
                  0.0, 0.0, 1.0, 0.0, 0.0, //
                  0.0, 0.0, 0.0, 1.0, 0.0, //
                ]),
      child: Image(
          image: AssetImage(imagePath),
          color: darkMode ? Colors.grey.shade400 : null,
          colorBlendMode: darkMode ? BlendMode.modulate : null),
    );
    return item.anyPlayer ?? false
        ? RedBorderedImage(imagePath: imagePath, child: coloredImage)
        : coloredImage;
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

  Widget _prepareImageView(String imagePath,
          {bool invertColor = false,
          bool greyColor = false,
          bool darkMode = false}) =>
      Stack(
        alignment: Alignment.center,
        children: [
          _applyRedBorderForImage(imagePath,
              invertColor: invertColor,
              greyColor: greyColor,
              darkMode: darkMode),
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
        itemWidthMultiplyer = (item.isPlayed ?? false) ? 1.0 : 1.5;
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

    Widget getMaView(String text) => Container(
        width: text.length * 7.5 + 15.0,
        height: height * 0.7,
        decoration: item.anyPlayer ?? false
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Colors.red,
                  width: 2.0,
                ),
              )
            : null,
        child: Container(
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
              text,
              style: TextStyle(
                fontSize: height * 0.4,
                fontFamily: FontFamily.prototype,
                color: Colors.black,
                height: 1.0,
              ),
            ),
          ),
        ));

    Widget createItem() {
      switch (item.type) {
        case CardRenderItemType.NEUTRAL_DELEGATE:
          return createGeneralTile(
            child: _prepareImageView(imagePath!, darkMode: true),
          );
        case CardRenderItemType.SELF_REPLICATING:
          final w = width * item.size.toMultiplier();
          final h = height * item.size.toMultiplier();
          return Container(
            width: w * 1.4,
            height: h * 1.6,
            child: Stack(children: [
              Container(
                padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
                width: w * 1.3,
                height: h * 1.6,
                child: Image(image: AssetImage(Assets.resources.card.path)),
              ),
              Row(children: [
                TagView(
                  imagePath: Tag.BUILDING.toImagePath()!,
                  tagRadius: h * 0.6,
                ),
                TagView(
                  imagePath: Tag.SPACE.toImagePath()!,
                  tagRadius: h * 0.6,
                )
              ]),
              Container(
                width: w * 0.6,
                height: h * 0.6,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: h * 0.8,
                  left: w * 0.35,
                  right: w * 0.35,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Text(
                  "2",
                  style: TextStyle(
                    fontSize: h * 0.5,
                    fontFamily: FontFamily.prototype,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
              ),
            ]),
          );
        case CardRenderItemType.MEGACREDITS:
          return createGeneralTile(
            child: CostView(
              height: width * item.size.toMultiplier(),
              width: height * item.size.toMultiplier(),
              cost: item.amount,
              text: item.clone == true ? "🪐" : item.innerText,
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
        case CardRenderItemType.CATHEDRAL:
          return createGeneralTile(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: _prepareImageView(imagePath!)));
        case CardRenderItemType.CARDS:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 0.9,
            heightMult: 1.6,
          );
        case CardRenderItemType.RULING_PARTY:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 1.7,
            heightMult: 1.3,
          );
        case CardRenderItemType.INFLUENCE:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 1.2,
            heightMult: 1.2,
          );
        case CardRenderItemType.EXCAVATE:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 1.35,
            heightMult: 1.35,
          );
        case CardRenderItemType.GREENERY:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 1.35,
            heightMult: 1.35,
          );
        case CardRenderItemType.VENUS:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: (item.isPlayed ?? false) ? 1.0 : 1.35,
            heightMult: (item.isPlayed ?? false) ? 1.0 : 1.35,
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
                    height: item.isBold == true ? 1.5 : 1.0,
                    color: Colors.black,
                    fontWeight: item.isBold == true
                        ? FontWeight.w700
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
                    color: Colors.black,
                    fontWeight: item.isBold == true
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ));
        case CardRenderItemType.TRADE_FLEET:
          return createGeneralTile(
            child: _prepareImageView(imagePath!, invertColor: true),
            widthMult: itemWidthMultiplyer,
            heightMult: 1.0,
          );
        case CardRenderItemType.REDS_DEACTIVATED:
          //сделать картинку черно-белой
          return createGeneralTile(
              child: _prepareImageView(imagePath!, greyColor: true));
        case CardRenderItemType.TRADE_DISCOUNT:
          return createGeneralTile(
            child: Container(
              alignment: Alignment.center,
              height: height * item.size.toMultiplier() * 0.9,
              width: height * item.size.toMultiplier() * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Text(
                item.amount.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: height * item.size.toMultiplier() * 0.7,
                  fontFamily: FontFamily.prototype,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
            ),
          );
        case CardRenderItemType.COMMUNITY:
          return createGeneralTile(
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
        case CardRenderItemType.INFERIOR_TR:
          return Stack(alignment: AlignmentDirectional.center, children: [
            Container(
                width: width * 1.5 * item.size.toMultiplier(),
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
                )),
            Padding(
              padding: EdgeInsets.only(
                  bottom: width * 0.2 * item.size.toMultiplier()),
              child: Text(
                ">",
                style: TextStyle(
                  fontSize: height * item.size.toMultiplier(),
                  fontFamily: FontFamily.ubuntu,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
            ),
          ]);
        case CardRenderItemType.NO_TAGS:
          return createGeneralTile(
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
          return createGeneralTile(
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
          addRedBorder(child) => Container(
              margin: EdgeInsets.only(left: width * 0.2),
              width: width * 3 * item.size.toMultiplier(),
              height: height * item.size.toMultiplier(),
              alignment: Alignment.center,
              decoration: item.anyPlayer ?? false
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    )
                  : null,
              child: child);
          return addRedBorder(Container(
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
          ));
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
          return getMaView("AWARD");
        case CardRenderItemType.MILESTONE:
          //нарисовать оранжевый прямоугольник с черным текстом внутри "MILESTONE"
          return getMaView("MILESTONE");
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
        case CardRenderItemType.GEOSCAN_ICON:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: 3.0,
            heightMult: 3.0,
          );
        case CardRenderItemType.MULTIPLIER_WHITE:
          return createGeneralTile(
            child: Container(
              width: width * item.size.toMultiplier(),
              height: height * item.size.toMultiplier(),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  "X",
                  style: TextStyle(
                    fontSize: height * item.size.toMultiplier() * 0.6,
                    fontFamily: FontFamily.prototype,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          );
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
                  Color.fromARGB(255, 201, 154, 0),
                  Color.fromARGB(255, 255, 196, 0),
                  Color.fromARGB(255, 255, 196, 0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.5,
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
        case CardRenderItemType.COLONIES:
          return createGeneralTile(
            child: _prepareImageView(imagePath!),
            widthMult: item.size == CardItemSize.MEDIUM ? 1.5 : 1.0,
            heightMult: item.size == CardItemSize.MEDIUM ? 1.5 : 1.0,
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
