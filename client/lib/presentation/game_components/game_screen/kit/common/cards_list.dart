import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';

class CardListView extends StatelessWidget {
  final List<Widget> cards;

  const CardListView({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double cardWidth = CARD_WIDTH * 1.1;
        final int crossAxisCount0 =
            (constraints.maxWidth - 40) / cardWidth ~/ 1;
        final int crossAxisCount = crossAxisCount0 < 1 ? 1 : crossAxisCount0;
        ScrollController _controller = ScrollController();
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade900,
            ),
            child: RawScrollbar(
                controller: _controller,
                thumbColor: Colors.white.withOpacity(0.5),
                thumbVisibility: true,
                radius: Radius.circular(4),
                thickness: 6,
                mainAxisMargin: 5,
                child: GridView.builder(
                  itemCount: cards.length,
                  padding: EdgeInsets.all(20.0),
                  controller: _controller,
                  itemBuilder: (context, index) => cards[index],
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 300.0,
                    crossAxisCount: crossAxisCount,
                  ),
                )));
      },
    );
  }
}
