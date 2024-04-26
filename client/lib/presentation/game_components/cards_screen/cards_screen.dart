import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/cards_view.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/iframe_cards_view.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/top_buttons_block.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leftPartController = ValueNotifier(
        bool.parse(localStorage.getItem('showFlutterCards') ?? 'true'));
    leftPartController.addListener(() {
      localStorage.setItem(
          'showFlutterCards', leftPartController.value.toString());
    });
    final rightPartController = ValueNotifier(
        bool.parse(localStorage.getItem('showGameServerCards') ?? 'true'));
    rightPartController.addListener(() {
      localStorage.setItem(
          'showGameServerCards', rightPartController.value.toString());
    });

    const topButtonBarHeight = 40.0;
    return Scaffold(
        body: Disposer(
      dispose: () {
        leftPartController.dispose();
        rightPartController.dispose();
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[700],
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(children: [
              Container(
                height: topButtonBarHeight,
                width: constraints.maxWidth,
                child: TopButtonsBlock(
                  onBack: () => context.go(MAIN_MENU_ROUTE),
                  showLeftBlock: leftPartController,
                  showRightBlock: rightPartController,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: leftPartController,
                builder: (context, showLeftPart, leftChild) {
                  return ValueListenableBuilder(
                    valueListenable: rightPartController,
                    builder: (context, showRightPart, rightChild) {
                      return Row(children: [
                        Container(
                          child: leftChild,
                          width: showLeftPart
                              ? showRightPart
                                  ? constraints.maxWidth / 2
                                  : constraints.maxWidth
                              : 0,
                          height: constraints.maxHeight - topButtonBarHeight,
                        ),
                        Container(
                          child: rightChild,
                          width: showRightPart
                              ? showLeftPart
                                  ? constraints.maxWidth / 2
                                  : constraints.maxWidth
                              : 0,
                          height: constraints.maxHeight - topButtonBarHeight,
                        ),
                      ]);
                    },
                    child: IframeCardsView(),
                  );
                },
                child: CardsView(
                  targetTypes: [CardType.CORPORATION],
                  cardsF: ClientCard.allCards,
                ),
              ),
            ]);
          })),
    ));
  }
}
