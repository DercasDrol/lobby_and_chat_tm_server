import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/common/cards_list.dart';

Widget cardsBuilderF(
        Future<List<ClientCard>> cardsF, List<CardType> targetTypes) =>
    Center(
      child: FutureBuilder<List<ClientCard>>(
        future: cardsF,
        builder:
            (BuildContext context, AsyncSnapshot<List<ClientCard>> snapshot) {
          if (snapshot.hasData &&
              (snapshot.data.runtimeType == List<ClientCard>) &&
              snapshot.data != null &&
              snapshot.data != []) {
            List<ClientCard> cards = snapshot.data!;
            //var cardsCount = cards.length;
            //var end = 56;
            cards.sort(
                ((a, b) => a.name.toString().compareTo(b.name.toString())));
            List<ClientCard> data = cards; //.sublist(
            //end > cardsCount ? 0 : end - cardsCount,
            //end > cardsCount ? cardsCount : end);
            List<ClientCard> filteredCards = data
                .where((cardInfo) => targetTypes.contains(cardInfo.type))
                .toList();

            return CardListView(
              cards: filteredCards
                  .map((card) => CardView(
                        card: card,
                        isSelected: false,
                        isDeactivated: false,
                      ))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Wrap(children: <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ]);
          } else {
            return Wrap(children: const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ]);
          }
        },
      ),
    );

Widget cardsBuilder(List<ClientCard> cards, List<CardType> targetTypes) {
  var cardsCount = cards.length;
  var end = 56;
  cards.sort(((a, b) => a.name.toString().compareTo(b.name.toString())));
  List<ClientCard> data = cards.sublist(end < cardsCount ? 0 : end - cardsCount,
      end < cardsCount ? cardsCount : end);
  List<ClientCard> filteredCards =
      data.where((cardInfo) => targetTypes.contains(cardInfo.type)).toList();

  return CardListView(
    cards: filteredCards
        .map((card) => CardView(
              card: card,
              isSelected: false,
              isDeactivated: false,
            ))
        .toList(),
  );
}
