import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/game_models/CardModel.dart';

class SelectedCards with ChangeNotifier {
  Map<CardName, ValueNotifier<bool>> cardNames;
  final Map<CardName, CardModel> cardModels;

  SelectedCards._({
    required this.cardNames,
    required this.cardModels,
  }) {
    _prepareListeners();
  }

  @override
  String toString() {
    return cardNames.toString();
  }

  @override
  dispose() {
    cardNames.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  _prepareListeners() {
    cardNames.forEach((key, value) {
      value.addListener(() {
        notifyListeners();
      });
    });
  }

  factory SelectedCards.fromList(List<CardModel> cards) {
    return SelectedCards._(
      cardModels: Map<CardName, CardModel>.fromIterable(
        cards,
        key: (card) => (card as CardModel).name,
        value: (card) => card,
      ),
      cardNames: Map<CardName, ValueNotifier<bool>>.fromIterable(
        cards,
        key: (card) => (card as CardModel).name,
        value: (card) => ValueNotifier(false),
      ),
    );
  }

  List<CardModel> get selectedCardModels {
    List<CardModel> res = [];
    cardNames.forEach((key, value) {
      if (value.value) {
        res.add(cardModels[key]!);
      }
    });
    return res;
  }
}
