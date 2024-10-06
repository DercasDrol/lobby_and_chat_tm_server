import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_amount_info.dart';

class AmountsNotifier with ChangeNotifier {
  final Map<PresentationAmountInfo, ValueNotifier<int>> amounts;

  AmountsNotifier._({
    required this.amounts,
  }) {
    _prepareListeners();
  }

  @override
  dispose() {
    amounts.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  _prepareListeners() {
    amounts.forEach((key, value) {
      value.addListener(() {
        notifyListeners();
      });
    });
  }

  factory AmountsNotifier.fromList(List<PresentationAmountInfo> amounts) {
    return AmountsNotifier._(
      amounts: Map<PresentationAmountInfo, ValueNotifier<int>>.fromIterable(
        amounts,
        key: (amount) => amount,
        value: (amount) => ValueNotifier(amount.value),
      ),
    );
  }

  List<PresentationAmountInfo> get changedAmounts => amounts.entries
      .map(
          (e) => e.key.copyWith(value: e.value.value) as PresentationAmountInfo)
      .toList();
}
