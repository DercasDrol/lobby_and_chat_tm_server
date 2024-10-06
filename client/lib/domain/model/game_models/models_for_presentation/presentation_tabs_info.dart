import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game_models/CardModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_amount_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_option_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tag_info.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';

class MegacreditsCounter extends Equatable {
  final int counter;
  final String? counterLable;

  MegacreditsCounter({
    required this.counter,
    this.counterLable,
  });

  @override
  List<Object?> get props => [counter, counterLable];
}

class PresentationTabInfo extends Equatable {
  final int? minCards;
  final int? maxCards;
  final List<CardModel>? cards;
  final List<CardModel>? disabledCards;
  final String tabTitle;
  final bool? showDiscount;
  final List<PresentationOptionInfo>? options;
  final List<PresentationAmountInfo>? amounts;

  PresentationTabInfo({
    this.minCards,
    this.maxCards,
    this.cards,
    required this.tabTitle,
    this.disabledCards,
    this.showDiscount,
    this.options,
    this.amounts,
  });

  @override
  List<Object?> get props => [
        cards,
        tabTitle,
        disabledCards,
        minCards,
        maxCards,
        options,
        amounts,
      ];
}

class UserActionInfo extends Equatable {
  final int tabIndex;
  final List<CardModel> leftTabCards;
  final List<CardModel>? midleTabCards;
  final List<CardModel> rightTabCards;
  final Payment? payment;
  final int? optionIndx;
  final List<PresentationAmountInfo>? amounts;

  UserActionInfo({
    this.midleTabCards,
    required this.tabIndex,
    required this.leftTabCards,
    required this.rightTabCards,
    this.payment,
    this.optionIndx,
    this.amounts,
  });

  @override
  List<Object?> get props => [
        tabIndex,
        leftTabCards,
        midleTabCards,
        rightTabCards,
        payment,
        optionIndx,
        amounts,
      ];
}

class PresentationTabsInfo extends Equatable {
  final PlayerColor playerColor;

  final PresentationTabInfo? rightTabInfo;
  final PresentationTabInfo? midleTabInfo;
  final PresentationTabInfo? leftTabInfo;
  final List<TagInfo>? tagsDiscounts;
  final int? allCardsDiscount;
  final bool? useEmptyTabView;

  final void Function()? Function(UserActionInfo)? getOnConfirmButtonFn;

  final String? Function(UserActionInfo)? getConfirmButtonText;

  final List<MegacreditsCounter>? Function(UserActionInfo)?
      getMegacreditsCounters;

  final PaymentInfo? Function(UserActionInfo)? getPaymentInfo;

  PresentationTabsInfo({
    this.getPaymentInfo,
    this.getMegacreditsCounters,
    required this.playerColor,
    this.getOnConfirmButtonFn,
    this.getConfirmButtonText,
    this.tagsDiscounts,
    this.allCardsDiscount,
    this.rightTabInfo,
    this.midleTabInfo,
    this.leftTabInfo,
    this.useEmptyTabView,
  });

  bool get onlyOneTabWithOptions =>
      this.rightTabInfo?.options != null &&
      this.midleTabInfo?.options == null &&
      this.leftTabInfo?.options == null &&
      this.rightTabInfo?.cards == null &&
      this.midleTabInfo?.cards == null &&
      this.leftTabInfo?.cards == null &&
      this.rightTabInfo?.disabledCards == null &&
      this.midleTabInfo?.disabledCards == null &&
      this.leftTabInfo?.disabledCards == null;

  @override
  List<Object?> get props => [
        playerColor,
        rightTabInfo,
        midleTabInfo,
        leftTabInfo,
        tagsDiscounts,
        allCardsDiscount,
        useEmptyTabView,
      ];
}
