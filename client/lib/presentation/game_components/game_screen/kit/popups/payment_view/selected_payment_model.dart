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

  int megaCredits;

  void megaCreditsDecrease() {
    if (megaCredits > 0) {
      megaCredits = megaCredits - 1;
      notifyListeners();
    }
  }

  void megaCreditsIncrease() {
    if (!correctSum &&
        megaCredits < paymentInfo.availablePayment.megaCredits &&
        megaCredits < paymentInfo.targetSum) {
      megaCredits = megaCredits + 1;
      notifyListeners();
    }
  }

  void megaCreditsMax() {
    setAll(
      mc: min(paymentInfo.availablePayment.megaCredits, paymentInfo.targetSum),
    );
  }

  int heat;

  void heatDecrease() {
    if (heat > 0) {
      heat = heat - 1;
      notifyListeners();
    }
  }

  void heatIncrease() {
    if (!correctSum &&
        heat < paymentInfo.availablePayment.heat &&
        heat < paymentInfo.targetSum) {
      heat = heat + 1;
      notifyListeners();
    }
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
    if (steel > 0) {
      steel = steel - 1;
      notifyListeners();
    }
  }

  void steelIncrease() {
    if (!correctSum &&
        steel < paymentInfo.availablePayment.steel &&
        steel * paymentInfo.steelValue < paymentInfo.targetSum) {
      steel = steel + 1;
      balance();
      notifyListeners();
    }
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
    if (titanium > 0) {
      titanium = titanium - 1;
      notifyListeners();
    }
  }

  void titaniumIncrease() {
    if (!correctSum &&
        titanium < paymentInfo.availablePayment.titanium &&
        titanium * paymentInfo.titaniumValue < paymentInfo.targetSum) {
      titanium = titanium + 1;
      balance();
      notifyListeners();
    }
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
    if (microbes > 0) {
      microbes = microbes - 1;
      notifyListeners();
    }
  }

  void microbesIncrease() {
    if (!correctSum &&
        microbes < paymentInfo.availablePayment.microbes &&
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
    if (floaters > 0) {
      floaters = floaters - 1;
      notifyListeners();
    }
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
    if (science > 0) {
      science = science - 1;
      notifyListeners();
    }
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
    if (seeds > 0) {
      seeds = seeds - 1;
      notifyListeners();
    }
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
    if (auroraiData > 0) {
      auroraiData = auroraiData - 1;
      notifyListeners();
    }
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
