import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';

class CardTooltip extends StatelessWidget {
  final CardName cardName;
  final int? cardResourceCount;
  final Widget child;
  const CardTooltip({
    super.key,
    required this.cardName,
    this.cardResourceCount,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      enableFeedback: true,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      waitDuration: Duration(milliseconds: 400),
      content: SizedBox(
        width: CARD_WIDTH * 1.1,
        height: CARD_HEIGHT * 1.1,
        child: CardView(
          sizeRatio: 1.1,
          card: ClientCard.fromCardName(cardName),
          resourcesCount: cardResourceCount,
          isDeactivated: false,
          isSelected: false,
        ),
      ),
      child: child,
    );
  }
}
