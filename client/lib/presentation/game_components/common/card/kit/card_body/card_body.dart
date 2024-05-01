import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';
import 'package:mars_flutter/domain/model/card/render/ICardRenderDescription.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/card_body_item.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/card_body_symbol.dart';
import 'package:mars_flutter/presentation/game_components/common/vpoints.dart';
import 'package:mars_flutter/presentation/game_components/common/tile_view.dart';
import 'package:mars_flutter/presentation/game_components/common/production_box.dart';

class CardBody extends StatelessWidget {
  final ClientCard card;
  final double width;
  final double height;
  get _calculatedSizeHeight => card.name.isComplexView ? height * 0.85 : height;
  const CardBody({
    required this.card,
    required this.width,
    required this.height,
  });

  Widget _getCardComponentView(CardComponent cardComponent) {
    final Widget res;
    switch (cardComponent.runtimeType) {
      case ICardRenderRoot:
        res = Column(
          mainAxisSize: MainAxisSize.min,
          children: (cardComponent as ICardRenderRoot)
              .rows
              .where((element) => element.isNotEmpty)
              .map(
                (cardComponents) => Padding(
                  padding: EdgeInsets.only(
                      bottom: card.name.isComplexView ? 0.0 : 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: cardComponents
                        .map((cardComponent0) => (cardComponent0.runtimeType ==
                                        ICardRenderItem &&
                                    (cardComponent0 as ICardRenderItem).type ==
                                        CardRenderItemType.TEXT) ||
                                cardComponent0.runtimeType == ICardRenderText
                            ? Flexible(
                                child: _getCardComponentView(cardComponent0),
                              )
                            : _getCardComponentView(cardComponent0))
                        .toList(),
                  ),
                ),
              )
              .toList(),
        );
        break;
      case ICardRenderText:
        res = (cardComponent as ICardRenderText).text == ''
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: width,
                      minHeight: 0,
                      maxWidth: width,
                      //maxHeight: height,
                    ),
                    child: Text(
                      cardComponent.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.05,
                        height: 1.0,
                      ),
                    )));
        break;
      case ICardRenderSymbol:
        res = BodySymbol(
          height: _calculatedSizeHeight * 0.15,
          width: _calculatedSizeHeight * 0.15,
          parentWidth: width,
          symbol: cardComponent as ICardRenderSymbol,
        );
        break;
      case ICardRenderTile:
        res = TileView(
          height: _calculatedSizeHeight * 0.26,
          width: _calculatedSizeHeight * 0.26,
          isCardTile: true,
          tileType: (cardComponent as ICardRenderTile).tile,
          isAres: cardComponent.isAres,
        );
        break;
      case ICardRenderProductionBox:
        res = ProductionBox(
            padding: 0.0,
            innerPadding: 3.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: (cardComponent as ICardRenderProductionBox)
                  .rows
                  .map(
                    (cardComponents) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                            children: cardComponents
                                .map((cardComponent0) =>
                                    _getCardComponentView(cardComponent0))
                                .toList())
                      ],
                    ),
                  )
                  .toList(),
            ));
        break;
      case ICardRenderEffect:
        res = Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: (cardComponent as ICardRenderEffect)
                .rows
                .map((cardComponents) => cardComponents
                    .map((cardComponent0) =>
                        _getCardComponentView(cardComponent0))
                    .toList())
                .expand((x) => x)
                .cast<Widget>()
                .toList());
        break;
      case ICardRenderCorpBoxEffect:
        res = Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: (cardComponent as ICardRenderCorpBoxEffect)
                .rows
                .map((cardComponents) => cardComponents
                    .map((cardComponent0) =>
                        _getCardComponentView(cardComponent0))
                    .toList())
                .expand((x) => x)
                .cast<Widget>()
                .toList());
        break;
      case ICardRenderCorpBoxAction:
        res = Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: (cardComponent as ICardRenderCorpBoxAction)
                .rows
                .map((cardComponents) => cardComponents
                    .map((cardComponent0) =>
                        _getCardComponentView(cardComponent0))
                    .toList())
                .expand((x) => x)
                .cast<Widget>()
                .toList());
        break;
      case ICardRenderItem:
        res = BodyItemView(
          item: (cardComponent as ICardRenderItem),
          height: _calculatedSizeHeight * 0.15,
          width: _calculatedSizeHeight * 0.15,
          parentWidth: width,
        );
        break;
      default:
        res = Text("default");
    }
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 0,
          minHeight: 0,
          maxWidth: width,
          maxHeight: height,
        ),
        child: res);
  }

  Widget _getCardDescription(ICardRenderDescription description) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 0,
        minHeight: 0,
        maxWidth: width,
        //maxHeight: height,
      ),
      child: Text(
        "(" + description.text + ")",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: width * 0.05,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _getMainBodyView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...(card.metadata.renderData != null)
            ? [_getCardComponentView(card.metadata.renderData!)]
            : [],
        ...(card.metadata.description != null &&
                card.metadata.description!.align == DescriptionAlign.CENTER
            ? [
                Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: _getCardDescription(card.metadata.description!))
              ]
            : [])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return card.metadata.victoryPoints == null
        ? _getMainBodyView()
        : Padding(
            padding: EdgeInsets.only(bottom: _calculatedSizeHeight * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...[_getMainBodyView()],
                ...(card.metadata.description != null &&
                        card.metadata.description!.align ==
                            DescriptionAlign.LEFT
                    ? [
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                              maxWidth: width,
                              maxHeight: height,
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                      child: _getCardDescription(
                                          card.metadata.description!)),
                                  VpointsView(
                                    width: width * 0.35,
                                    height: _calculatedSizeHeight * 0.2,
                                    points: card.metadata.victoryPoints!,
                                    isCardPoints: true,
                                  )
                                ]))
                      ]
                    : [
                        Padding(
                            padding: EdgeInsets.only(right: width * 0.06),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: VpointsView(
                                width: width * 0.35,
                                height: _calculatedSizeHeight * 0.2,
                                points: card.metadata.victoryPoints!,
                                isCardPoints: true,
                              ),
                            ))
                      ]),
              ],
            ));
  }
}
