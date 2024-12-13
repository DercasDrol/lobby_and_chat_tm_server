import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tag_info.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/show_popup_with_tabs.dart';

class MainCardsButton extends StatelessWidget {
  final int cardsInHandsCount;
  final Map<CardType, int>? cardsAvailableForPlayCount;
  final double width;
  final int allCardsDiscount;
  final PresentationTabsInfo tabsInfo;
  final List<TagInfo> tagsInfo;

  const MainCardsButton({
    super.key,
    required this.cardsAvailableForPlayCount,
    required this.cardsInHandsCount,
    required this.width,
    required this.tabsInfo,
    required this.allCardsDiscount,
    required this.tagsInfo,
  });

  @override
  Widget build(BuildContext context) {
    final bool showCardsAvailableForPlayCount =
        cardsAvailableForPlayCount != null ||
            tabsInfo.leftTabInfo?.cards != null ||
            tabsInfo.leftTabInfo?.disabledCards != null;
    Widget createField(CardType cardType) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: cardType.toColor(),
          ),
          child: SizedBox(
            width: width * 0.18,
            height: width * 0.30,
            child: !showCardsAvailableForPlayCount
                ? SizedBox.shrink()
                : Text(
                    textAlign: TextAlign.center,
                    cardsAvailableForPlayCount?[cardType]?.toString() ?? '0',
                    style: MAIN_TEXT_STYLE,
                  ),
          ),
        );
    return SizedBox(
      width: width,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        minWidth: 0,
        onPressed: () =>
            showPopupWithTabs(context: context, tabsInfo: tabsInfo),
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Tooltip(
            message: (!showCardsAvailableForPlayCount
                    ? ''
                    : 'Cards are available for play: ${(cardsAvailableForPlayCount?.values.fold(0, (acc, e) => acc + e) ?? 0).toString()} \n') +
                'Cards in hands: $cardsInHandsCount | Played cards: ${tabsInfo.rightTabInfo?.cards?.length}',
            textStyle: TextStyle(fontSize: 16, color: Colors.white),
            waitDuration: Duration(milliseconds: 500),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: width - 20.0,
                    padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Color.fromARGB(117, 0, 0, 0),
                    ),
                    child: Column(children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          createField(CardType.ACTIVE),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: createField(CardType.AUTOMATED),
                          ),
                          createField(CardType.EVENT),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 6,
                            child: FittedBox(
                              child: Text(
                                cardsInHandsCount.toString(),
                                style: MAIN_TEXT_STYLE.copyWith(
                                    fontSize: width * 0.22),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: FittedBox(
                              child: Text(
                                "|",
                                style: TextStyle(
                                    color: tabsInfo.playerColor.toColor(true)),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: FittedBox(
                              child: Text(
                                tabsInfo.rightTabInfo?.cards?.length
                                        .toString() ??
                                    '0',
                                style: MAIN_TEXT_STYLE.copyWith(
                                    fontSize: width * 0.22),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: allCardsDiscount > 0
                      ? CostView(
                          cost: -allCardsDiscount,
                          width: width * 0.25,
                          height: width * 0.25,
                          multiplier: false,
                          useGreyMode: false,
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
