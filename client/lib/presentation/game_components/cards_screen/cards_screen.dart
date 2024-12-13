import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/repositories.dart';
import 'package:mars_flutter/presentation/core/common_future_widget.dart';
import 'package:mars_flutter/presentation/game_components/common/cards_view/cards_view.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/iframe_cards_view.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cards'),
            bottom: TabBar(
              tabs: [Tab(text: "Flutter cards"), Tab(text: "Vue cards")],
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              labelStyle: TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              CardsView(
                targetTypes: CardType.values,
                cardsF: ClientCard.allCards,
              ),
              CommonFutureWidget<String>(
                future: Repositories.game.host,
                getContentView: (host) => IframeCardsView(host: host),
              ),
            ],
          ),
        ));
  }
}
