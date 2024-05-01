import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderSymbolType.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/utils.dart';

class BodySymbol extends StatelessWidget {
  const BodySymbol({
    required this.symbol,
    required this.width,
    required this.height,
    required this.parentWidth,
  });

  final ICardRenderSymbol symbol;
  final double width;
  final double height;
  final double parentWidth;

  @override
  Widget build(BuildContext context) {
    switch (symbol.type) {
      case CardRenderSymbolType.ASTERIX:
        return BodyItemCover(
          width: width * symbol.size.toMultiplier() * 0.4,
          height: height * symbol.size.toMultiplier() * 0.5,
          parentHeight: height,
          child: Image(image: AssetImage(Assets.misc.asterisc.path)),
        );
      case CardRenderSymbolType.OR:
        return Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              CardRenderSymbolType.OR.toStringForUI(),
              style: TextStyle(
                fontSize: height * 0.5,
                fontFamily: FontFamily.prototype,
                color: Colors.black,
              ),
            ));
      case CardRenderSymbolType.MINUS:
        return BodyItemCover(
          child: Image(image: AssetImage(Assets.misc.minus.path)),
          width: width * symbol.size.toMultiplier() * 0.5,
          height: height * symbol.size.toMultiplier() * 0.45,
          parentHeight: height,
        );
      case CardRenderSymbolType.PLUS:
        return BodyItemCover(
          child: Image(image: AssetImage(Assets.misc.plus.path)),
          width: width * symbol.size.toMultiplier() * 0.5,
          height: height * symbol.size.toMultiplier() * 0.35,
          parentHeight: height,
        );
      case CardRenderSymbolType.COLON:
        return BodyItemCover(
          child: Image(image: AssetImage(Assets.misc.colon.path)),
          width: width * symbol.size.toMultiplier() * 0.45,
          height: height * symbol.size.toMultiplier() * 0.35,
          parentHeight: height,
        );
      case CardRenderSymbolType.EMPTY:
        return BodyItemCover(
          text: CardRenderSymbolType.EMPTY.toStringForUI(),
          width: width * symbol.size.toMultiplier() * 0.2,
          height: height * symbol.size.toMultiplier() * 0.2,
          parentHeight: height,
        );
      case CardRenderSymbolType.SLASH:
        return BodyItemCover(
          child: Image(image: AssetImage(Assets.misc.bar.path)),
          width: width * symbol.size.toMultiplier() * 0.3,
          height: height * symbol.size.toMultiplier() * 0.7,
          parentHeight: height,
        );
      case CardRenderSymbolType.ARROW:
        return BodyItemCover(
          child: Image(image: AssetImage(Assets.misc.arrow.path)),
          width: width * symbol.size.toMultiplier() * 1.0,
          height: height * symbol.size.toMultiplier() * 0.4,
          parentHeight: height,
        );
      case CardRenderSymbolType.BRACKET_OPEN:
        return BodyItemCover(
          text: CardRenderSymbolType.BRACKET_OPEN.toStringForUI(),
          width: width * symbol.size.toMultiplier() * 0.3,
          height: height * symbol.size.toMultiplier() * 1.0,
          parentHeight: height,
        );
      case CardRenderSymbolType.BRACKET_CLOSE:
        return BodyItemCover(
          text: CardRenderSymbolType.BRACKET_CLOSE.toStringForUI(),
          width: width * symbol.size.toMultiplier() * 0.3,
          height: height * symbol.size.toMultiplier() * 1.0,
          parentHeight: height,
        );
      case CardRenderSymbolType.NBSP:
        return BodyItemCover(
          text: CardRenderSymbolType.NBSP.toStringForUI(),
          width: width * symbol.size.toMultiplier() * 0.2,
          height: height * symbol.size.toMultiplier() * 0.5,
          parentHeight: height,
        );
      case CardRenderSymbolType.VSPACE:
        return BodyItemCover(
          child: SizedBox.shrink(),
          width: parentWidth,
          height: 0.0,
          parentHeight: height * symbol.size.toMultiplier() * 0.3,
        );
      case CardRenderSymbolType.EQUALS:
        return BodyItemCover(
          text: CardRenderSymbolType.EQUALS.toStringForUI(),
          width: width * symbol.size.toMultiplier() * 0.5,
          height: height * symbol.size.toMultiplier() * 0.5,
          parentHeight: height,
        );
      case CardRenderSymbolType.SURVEY_MISSION:
        return BodyItemCover(
          text: CardRenderSymbolType.SURVEY_MISSION.toStringForUI(),
          width: width * symbol.size.toMultiplier() * 0.5,
          height: height * symbol.size.toMultiplier() * 0.5,
          parentHeight: height,
        );
      case CardRenderSymbolType.UNKNOWN:
        return SizedBox.shrink();
    }
  }
}
