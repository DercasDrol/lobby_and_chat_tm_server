import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/cards_builder.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/');
          },
          child: Icon(Icons.arrow_back),
        ),
        body: cardsBuilderF(
          Future.delayed(Duration(seconds: 2), () => ClientCard.allCards),
          [CardType.CORPORATION],
        ));
  }
}
