import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';

class SelectedPayment with ChangeNotifier {
  final PaymentInfo paymentInfo;

  int graphene;
  int get remainingSum =>
      paymentInfo.targetSum -
      megaCredits -
      heat -
      (steel * paymentInfo.steelValue) -
      (titanium * paymentInfo.titaniumValue) -
      microbes * PaymentInfo.microbesValue -
      floaters * PaymentInfo.floatersValue -
      science * PaymentInfo.lunaArchivesScienceValue -
      seeds * PaymentInfo.seedsValue -
      auroraiData;

  bool get correctSum => remainingSum <= 0;
  int get currentSum =>
      megaCredits +
      heat +
      (steel * paymentInfo.steelValue) +
      (titanium * paymentInfo.titaniumValue) +
      microbes * PaymentInfo.microbesValue +
      floaters * PaymentInfo.floatersValue +
      science * PaymentInfo.lunaArchivesScienceValue +
      seeds * PaymentInfo.seedsValue +
      auroraiData;

  void balance() {
    if (remainingSum < 0 && megaCredits > 0) {
      megaCreditsDecrease();
      balance();
    } else if (remainingSum < 0 && heat > 0) {
      heatDecrease();
      balance();
    } else if (remainingSum < 0 && microbes > 0) {
      microbesDecrease();
      balance();
    } else if (remainingSum < 0 && floaters > 0) {
      floatersDecrease();
      balance();
    } else if (remainingSum < 0 && science > 0) {
      scienceDecrease();
      balance();
    } else if (remainingSum < 0 && seeds > 0) {
      seedsDecrease();
      balance();
    } else if (remainingSum < 0 && auroraiData > 0) {
      auroraiDataDecrease();
      balance();
    } else if (remainingSum < -1 && steel > 0) {
      steelDecrease();
      balance();
    } else if (remainingSum < -2 && titanium > 0) {
      titaniumDecrease();
      balance();
    } else if (remainingSum > 0 && megaCredits > 0) {
      megaCreditsIncrease();
      balance();
    } else if (remainingSum > 0 && steel > 0) {
      steelIncrease();
      balance();
    } else if (remainingSum > 0 && titanium > 0) {
      titaniumIncrease();
      balance();
    }
  }

  void setAll({
    int mc = 0,
    int heat = 0,
    int steel = 0,
    int titanium = 0,
    int microbes = 0,
    int floaters = 0,
    int science = 0,
    int seeds = 0,
    int auroraiData = 0,
  }) {
    this.megaCredits = max(mc, 0);
    this.heat = max(heat, 0);
    this.steel = max(steel, 0);
    this.titanium = max(titanium, 0);
    this.microbes = max(microbes, 0);
    this.floaters = max(floaters, 0);
    this.science = max(science, 0);
    this.seeds = max(seeds, 0);
    this.auroraiData = max(auroraiData, 0);

    notifyListeners();
  }

  int _getResorceById(int id) {
    switch (id) {
      case 0:
        return megaCredits;
      case 1:
        return heat;
      case 2:
        return steel;
      case 3:
        return titanium;
      case 4:
        return microbes;
      case 5:
        return floaters;
      case 6:
        return science;
      case 7:
        return seeds;
      case 8:
        return auroraiData;
      default:
        return 0;
    }
  }

  void _setResorceById(int id, int value) {
    if (value < 0) {
      return;
    }
    switch (id) {
      case 0:
        megaCredits = value;
        break;
      case 1:
        heat = value;
        break;
      case 2:
        steel = value;
        break;
      case 3:
        titanium = value;
        break;
      case 4:
        microbes = value;
        break;
      case 5:
        floaters = value;
        break;
      case 6:
        science = value;
        break;
      case 7:
        seeds = value;
        break;
      case 8:
        auroraiData = value;
        break;
      default:
        break;
    }
    balance();
    notifyListeners();
  }

  int megaCredits;
  void increaseFn(int resourceId, int availableResourceCount, int cost) {
    if (_getResorceById(resourceId) < availableResourceCount &&
        _getResorceById(resourceId) * cost < paymentInfo.targetSum) {
      _setResorceById(resourceId, _getResorceById(resourceId) + 1);
    }
  }

  void megaCreditsDecrease() {
    _setResorceById(0, megaCredits - 1);
  }

  void megaCreditsIncrease() {
    increaseFn(0, paymentInfo.availablePayment.megaCredits, 1);
  }

  void megaCreditsMax() {
    setAll(
      mc: min(paymentInfo.availablePayment.megaCredits, paymentInfo.targetSum),
    );
  }

  int heat;

  void heatDecrease() {
    _setResorceById(1, heat - 1);
  }

  void heatIncrease() {
    increaseFn(1, paymentInfo.availablePayment.heat, PaymentInfo.heat);
  }

  void heatMax() {
    final int maxHeat =
        min(paymentInfo.availablePayment.heat, paymentInfo.targetSum);
    setAll(
      mc: min(paymentInfo.availablePayment.megaCredits,
          paymentInfo.targetSum - maxHeat),
      heat: maxHeat,
    );
  }

  int steel;

  void steelDecrease() {
    _setResorceById(2, steel - 1);
  }

  void steelIncrease() {
    increaseFn(
      2,
      paymentInfo.availablePayment.steel,
      paymentInfo.steelValue,
    );
  }

  void steelMax() {
    final int maxSteel = min(
      paymentInfo.availablePayment.steel,
      (paymentInfo.targetSum / paymentInfo.steelValue + 0.5).round(),
    );
    setAll(
      mc: min(
        paymentInfo.availablePayment.megaCredits,
        paymentInfo.targetSum - maxSteel * paymentInfo.steelValue,
      ),
      steel: maxSteel,
    );
  }

  int titanium;

  void titaniumDecrease() {
    _setResorceById(3, titanium - 1);
  }

  void titaniumIncrease() {
    increaseFn(
      3,
      paymentInfo.availablePayment.titanium,
      paymentInfo.titaniumValue,
    );
  }

  void titaniumMax() {
    final int maxTitanium = min(
      paymentInfo.availablePayment.titanium,
      (paymentInfo.targetSum / paymentInfo.titaniumValue + 0.5).round(),
    );
    setAll(
      mc: min(
        paymentInfo.availablePayment.megaCredits,
        paymentInfo.targetSum - maxTitanium * paymentInfo.titaniumValue,
      ),
      titanium: maxTitanium,
    );
  }

  int microbes;

  void microbesDecrease() {
    _setResorceById(1, microbes - 1);
  }

  void microbesIncrease() {
    if (microbes < paymentInfo.availablePayment.microbes &&
        microbes * PaymentInfo.microbesValue < paymentInfo.targetSum) {
      microbes = microbes + 1;
      notifyListeners();
    }
  }

  void microbesMax() {
    final int maxMicrobes = min(
      paymentInfo.availablePayment.microbes,
      (paymentInfo.targetSum / PaymentInfo.microbesValue + 0.5).round(),
    );
    setAll(
      mc: min(paymentInfo.availablePayment.megaCredits,
          paymentInfo.targetSum - maxMicrobes * PaymentInfo.microbesValue),
      microbes: maxMicrobes,
    );
  }

  int floaters;

  void floatersDecrease() {
    _setResorceById(1, floaters - 1);
  }

  void floatersIncrease() {
    if (!correctSum &&
        floaters < paymentInfo.availablePayment.floaters &&
        floaters * PaymentInfo.floatersValue < paymentInfo.targetSum) {
      floaters = floaters + 1;
      notifyListeners();
    }
  }

  void floatersMax() {
    final int maxFloaters = min(
      paymentInfo.availablePayment.floaters,
      (paymentInfo.targetSum / PaymentInfo.floatersValue + 0.5).round(),
    );
    setAll(
      mc: min(paymentInfo.availablePayment.megaCredits,
          paymentInfo.targetSum - maxFloaters * PaymentInfo.floatersValue),
      floaters: maxFloaters,
    );
  }

  int science;

  void scienceDecrease() {
    _setResorceById(1, science - 1);
  }

  void scienceIncrease() {
    if (!correctSum &&
        science < paymentInfo.availablePayment.lunaArchivesScience &&
        science * PaymentInfo.lunaArchivesScienceValue <
            paymentInfo.targetSum) {
      science = science + 1;
      notifyListeners();
    }
  }

  void scienceMax() {
    final int maxScience = min(
      paymentInfo.availablePayment.lunaArchivesScience,
      (paymentInfo.targetSum / PaymentInfo.lunaArchivesScienceValue + 0.5)
          .round(),
    );
    setAll(
      mc: min(
          paymentInfo.availablePayment.megaCredits,
          paymentInfo.targetSum -
              maxScience * PaymentInfo.lunaArchivesScienceValue),
      science: maxScience,
    );
  }

  int seeds;

  void seedsDecrease() {
    _setResorceById(1, seeds - 1);
  }

  void seedsIncrease() {
    if (!correctSum &&
        seeds < paymentInfo.availablePayment.seeds &&
        seeds * PaymentInfo.seedsValue < paymentInfo.targetSum) {
      seeds = seeds + 1;
      notifyListeners();
    }
  }

  void seedsMax() {
    final int maxSeeds = min(
      paymentInfo.availablePayment.seeds,
      (paymentInfo.targetSum / PaymentInfo.seedsValue + 0.5).round(),
    );
    setAll(
      mc: min(paymentInfo.availablePayment.megaCredits,
          paymentInfo.targetSum - maxSeeds * PaymentInfo.seedsValue),
      seeds: maxSeeds,
    );
  }

  int auroraiData;

  void auroraiDataDecrease() {
    _setResorceById(1, auroraiData - 1);
  }

  void auroraiDataIncrease() {
    if (!correctSum &&
        auroraiData < paymentInfo.availablePayment.auroraiData &&
        auroraiData * PaymentInfo.auroraiData < paymentInfo.targetSum) {
      auroraiData = auroraiData + 1;
      notifyListeners();
    }
  }

  void auroraiDataMax() {
    final int maxAuroraiData = min(
      paymentInfo.availablePayment.auroraiData,
      (paymentInfo.targetSum / PaymentInfo.auroraiData + 0.5).round(),
    );
    setAll(
      mc: min(paymentInfo.availablePayment.megaCredits,
          paymentInfo.targetSum - maxAuroraiData * PaymentInfo.auroraiData),
      auroraiData: maxAuroraiData,
    );
  }

  SelectedPayment._({
    required this.paymentInfo,
    required this.megaCredits,
    required this.heat,
    required this.steel,
    required this.titanium,
    required this.microbes,
    required this.floaters,
    required this.science,
    required this.seeds,
    required this.auroraiData,
    required this.graphene,
  }) {}

  factory SelectedPayment.fromPaymentInfo(PaymentInfo paymentInfo) {
    final int maxMc =
        min(paymentInfo.availablePayment.megaCredits, paymentInfo.targetSum);
    final int maxHeat =
        min(paymentInfo.availablePayment.heat, paymentInfo.targetSum - maxMc);
    final int maxSteel = min(
      paymentInfo.availablePayment.steel,
      ((paymentInfo.targetSum - maxMc - maxHeat) / paymentInfo.steelValue)
          .floor(),
    );
    final int maxTitanium = min(
      paymentInfo.availablePayment.titanium,
      ((paymentInfo.targetSum -
                  maxMc -
                  maxHeat -
                  maxSteel * paymentInfo.steelValue) /
              paymentInfo.titaniumValue)
          .floor(),
    );
    final int maxMicrobes = min(
      paymentInfo.availablePayment.microbes,
      paymentInfo.targetSum -
          maxMc -
          maxHeat -
          maxSteel * paymentInfo.steelValue -
          maxTitanium * paymentInfo.titaniumValue,
    );
    final int maxFloaters = min(
      paymentInfo.availablePayment.floaters,
      paymentInfo.targetSum -
          maxMc -
          maxHeat -
          maxSteel * paymentInfo.steelValue -
          maxTitanium * paymentInfo.titaniumValue -
          maxMicrobes * PaymentInfo.microbesValue,
    );
    final int maxScience = min(
      paymentInfo.availablePayment.lunaArchivesScience,
      paymentInfo.targetSum -
          maxMc -
          maxHeat -
          maxSteel * paymentInfo.steelValue -
          maxTitanium * paymentInfo.titaniumValue -
          maxMicrobes * PaymentInfo.microbesValue -
          maxFloaters * PaymentInfo.floatersValue,
    );
    final int maxSeeds = min(
      paymentInfo.availablePayment.seeds,
      paymentInfo.targetSum -
          maxMc -
          maxHeat -
          maxSteel * paymentInfo.steelValue -
          maxTitanium * paymentInfo.titaniumValue -
          maxMicrobes * PaymentInfo.microbesValue -
          maxFloaters * PaymentInfo.floatersValue -
          maxScience * PaymentInfo.lunaArchivesScienceValue,
    );
    final int maxAuroraiData = min(
      paymentInfo.availablePayment.auroraiData,
      paymentInfo.targetSum -
          maxMc -
          maxHeat -
          maxSteel * paymentInfo.steelValue -
          maxTitanium * paymentInfo.titaniumValue -
          maxMicrobes * PaymentInfo.microbesValue -
          maxFloaters * PaymentInfo.floatersValue -
          maxScience * PaymentInfo.lunaArchivesScienceValue -
          maxSeeds * PaymentInfo.seedsValue,
    );
    final int graphene = min(
      paymentInfo.availablePayment.graphene,
      paymentInfo.targetSum -
          maxMc -
          maxHeat -
          maxSteel * paymentInfo.steelValue -
          maxTitanium * paymentInfo.titaniumValue -
          maxMicrobes * PaymentInfo.microbesValue -
          maxFloaters * PaymentInfo.floatersValue -
          maxScience * PaymentInfo.lunaArchivesScienceValue -
          maxSeeds * PaymentInfo.seedsValue -
          paymentInfo.availablePayment.auroraiData * PaymentInfo.auroraiData,
    );
    return SelectedPayment._(
      paymentInfo: paymentInfo,
      megaCredits: maxMc,
      heat: maxHeat,
      steel: maxSteel,
      titanium: maxTitanium,
      microbes: maxMicrobes,
      floaters: maxFloaters,
      science: maxScience,
      seeds: maxSeeds,
      auroraiData: maxAuroraiData,
      graphene: graphene,
    );
  }

  Payment get payment {
    return Payment(
      megaCredits: megaCredits,
      heat: heat,
      steel: steel,
      titanium: titanium,
      microbes: microbes,
      floaters: floaters,
      lunaArchivesScience: science,
      seeds: seeds,
      auroraiData: auroraiData,
      graphene: graphene,
      kuiperAsteroids: 0,
      spireScience: 0,
      corruption: 0,
      plants: 0,
    );
  }

  List<PresentationInfo> get presentationInfos {
    return [
      ...this.paymentInfo.availablePayment.megaCredits > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.megacredit.path,
                onDecreaseButtonFn: megaCreditsDecrease,
                onIncreaseButtonFn: megaCreditsIncrease,
                onMaxButtonFn: megaCreditsMax,
                value: megaCredits,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.heat > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.heat.path,
                onDecreaseButtonFn: heatDecrease,
                onIncreaseButtonFn: heatIncrease,
                onMaxButtonFn: heatMax,
                value: heat,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.steel > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.steel.path,
                onDecreaseButtonFn: steelDecrease,
                onIncreaseButtonFn: steelIncrease,
                onMaxButtonFn: steelMax,
                value: steel,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.titanium > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.titanium.path,
                onDecreaseButtonFn: titaniumDecrease,
                onIncreaseButtonFn: titaniumIncrease,
                onMaxButtonFn: titaniumMax,
                value: titanium,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.microbes > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.microbe.path,
                onDecreaseButtonFn: microbesDecrease,
                onIncreaseButtonFn: microbesIncrease,
                onMaxButtonFn: microbesMax,
                value: microbes,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.floaters > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.floater.path,
                onDecreaseButtonFn: floatersDecrease,
                onIncreaseButtonFn: floatersIncrease,
                onMaxButtonFn: floatersMax,
                value: floaters,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.lunaArchivesScience > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.science.path,
                onDecreaseButtonFn: scienceDecrease,
                onIncreaseButtonFn: scienceIncrease,
                onMaxButtonFn: scienceMax,
                value: science,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.seeds > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.seed.path,
                onDecreaseButtonFn: seedsDecrease,
                onIncreaseButtonFn: seedsIncrease,
                onMaxButtonFn: seedsMax,
                value: seeds,
              )
            ]
          : [],
      ...this.paymentInfo.availablePayment.auroraiData > 0
          ? [
              PresentationInfo(
                iconPath: Assets.resources.data.path,
                onDecreaseButtonFn: auroraiDataDecrease,
                onIncreaseButtonFn: auroraiDataIncrease,
                onMaxButtonFn: auroraiDataMax,
                value: auroraiData,
              )
            ]
          : [],
    ];
  }
}

class PresentationInfo {
  final void Function() onDecreaseButtonFn;
  final void Function() onIncreaseButtonFn;
  final void Function() onMaxButtonFn;
  final String iconPath;
  final int value;

  PresentationInfo({
    required this.iconPath,
    required this.onDecreaseButtonFn,
    required this.onIncreaseButtonFn,
    required this.onMaxButtonFn,
    required this.value,
  });
}
