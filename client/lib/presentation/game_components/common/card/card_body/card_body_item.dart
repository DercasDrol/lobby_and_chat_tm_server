import 'dart:core';

import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_body/utils.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_utils.dart';

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
  Widget _applyPadding(
      {required Widget child,
      double? widthMultiplier,
      double? heightMultiplier}) {
    final itemWidth =
        width * item.size.toMultiplier() * (widthMultiplier ?? 1.0);
    final res = Padding(
      padding: EdgeInsets.all(1),
      child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: itemWidth,
            maxHeight:
                height * item.size.toMultiplier() * (heightMultiplier ?? 1.0),
          ),
          child: child),
    );
    return (item.anyPlayer ?? false) && item.type.toItemShape() != null
        ? RedItemBox(
            child: res,
            width: itemWidth,
            shape: item.type.toItemShape()!,
          )
        : res;
  }

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
      default:
        itemWidthMultiplyer =
            item.type.toItemShape() == ItemShape.hexagon ? 1.4 : 1.0;
        break;
    }
    final String? imagePath =
        item.type.toImagePath(item.isPlayed == null ? false : item.isPlayed!);

    Widget createGeneralTile() {
      return _applyPadding(
        child: Image(image: AssetImage(imagePath!)),
        widthMultiplier: itemWidthMultiplyer,
        heightMultiplier: itemWidthMultiplyer,
      );
    }

    Widget createItem() {
      switch (item.type) {
        case CardRenderItemType.MEGACREDITS:
          return _applyPadding(
            child: CostView(
              height: width * item.size.toMultiplier(),
              width: height * item.size.toMultiplier(),
              fontSize: height * item.size.toMultiplier() * 0.56,
              cost: item.amount,
              multiplier: false,
              useGreyMode: false,
            ),
          );
        case CardRenderItemType.CITY:
          return createGeneralTile();
        case CardRenderItemType.GREENERY:
          return createGeneralTile();
        case CardRenderItemType.OCEANS:
          return createGeneralTile();
        case CardRenderItemType.TR:
          return createGeneralTile();
        case CardRenderItemType.OXYGEN:
          return createGeneralTile();
        case CardRenderItemType.TEMPERATURE:
          return _applyPadding(
            child: Image(image: AssetImage(imagePath!)),
            widthMultiplier: 1.0,
            heightMultiplier: 1.5,
          );
        case CardRenderItemType.CARDS:
          return _applyPadding(
            child: Image(image: AssetImage(imagePath!)),
            widthMultiplier: 0.9,
            heightMultiplier: 1.5,
          );
        case CardRenderItemType.RULING_PARTY:
          return _applyPadding(
            child: Image(image: AssetImage(imagePath!)),
            widthMultiplier: 1.7,
            heightMultiplier: 1.3,
          );
        case CardRenderItemType.INFLUENCE:
          return _applyPadding(
            child: Image(image: AssetImage(imagePath!)),
            widthMultiplier: 1.2,
            heightMultiplier: 1.2,
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
                  child: Container(
                    width: parentWidth * 0.6,
                    height: height * 1.4,
                    alignment: Alignment.center,
                    child: Text(
                      item.text == null ? "" : item.text!.toUpperCase(),
                      textAlign: TextAlign.center,
                      textWidthBasis: TextWidthBasis.longestLine,
                      style: TextStyle(
                        fontSize: height * item.size.toMultiplier() * 0.45,
                        fontFamily: FontFamily.prototype,
                        color: Colors.black,
                        fontWeight: item.isBold == true
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  )));
        case CardRenderItemType.TRADE_FLEET:
          //добавить инверсию цвета в картинке
          return _applyPadding(child: Image(image: AssetImage(imagePath!)));
        case CardRenderItemType.REDS_DEACTIVATED:
          //сделать картинку черно-белой
          return _applyPadding(child: Image(image: AssetImage(imagePath!)));
        case CardRenderItemType.TRADE_DISCOUNT:
          //сделать белый квадрат с черным текстом внутри
          return _applyPadding(
            child: BodyItemCover(
              text: item.text,
              height: height * item.size.toMultiplier() * 0.4,
              width: width * item.size.toMultiplier(),
              parentHeight: height,
            ),
          );
        case CardRenderItemType.COMMUNITY:
          //нарисовать пустой квадрат с оранжевой градиентной заливкой
          return SizedBox.shrink();
        case CardRenderItemType.DIVERSE_TAG:
          //нарисовать пустой круг с градиентной заливкой от зеленого до красного
          return SizedBox.shrink();
        case CardRenderItemType.PRELUDE:
          //нарисовать металлический прямоугольник внутри которго будет розовый прямоугольник с надписью "PREL"
          return SizedBox.shrink();

        case CardRenderItemType.IGNORE_GLOBAL_REQUIREMENTS:
          //нарисовать желтый прямоугольник с черным текстом внутри "GLOBAL REQUIREMENTS" С Х посередине перекрывая плашку
          return SizedBox.shrink();
        case CardRenderItemType.AWARD:
          //нарисовать оранжевый прямоугольник с черным текстом внутри "AWARD"
          return SizedBox.shrink();
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
          //взять картинку delegate на фоне черном надгробии
          return SizedBox.shrink();
        case CardRenderItemType.VP:
          //отрисовать уменьшенный фон для вп с вопросом внутри
          return SizedBox.shrink();
        case CardRenderItemType.MULTIPLIER_WHITE:
          //отрисовать белый квадрат с черным Х внутри
          return SizedBox.shrink();
        default:
          if (item.amount.abs() > 1 && item.showDigit == true) {
            return Wrap(children: [
              BodyItemCover(
                text: item.amount.abs().toString(),
                height: height * item.size.toMultiplier() * 0.8,
                width: width * item.size.toMultiplier() * 0.4,
                parentHeight: height,
              ),
              _applyPadding(child: Image(image: AssetImage(imagePath!))),
            ]);
          } else {
            return _applyPadding(child: Image(image: AssetImage(imagePath!)));
          }
      }
    }

    final itemWidth = width * item.size.toMultiplier() * itemWidthMultiplyer;
    if (item.amount.abs() > 1 &&
        item.showDigit == false &&
        item.amountInside != true) {
      return Table(defaultColumnWidth: FixedColumnWidth(itemWidth), children: [
        TableRow(
          children: Iterable<int>.generate(item.amount.abs())
              .map((_) => createItem())
              .toList(),
        )
      ]);
    } else {
      return createItem();
    }
  }
}
