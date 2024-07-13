import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/common/popups_register.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/payment_view/payment_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/selected_cards_model.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/tabs/container_with_tabs.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';

void showPopupWithTabs({
  required final BuildContext context,
  required final PresentationTabsInfo tabsInfo,
  required double topPadding,
  required double bottomPadding,
}) {
  final SelectedCards rightTabSelectedCards =
      SelectedCards.fromList(tabsInfo.rightTabInfo?.cards ?? []);
  final SelectedCards leftTabSelectedCards =
      SelectedCards.fromList(tabsInfo.leftTabInfo?.cards ?? []);

  final SelectedCards midleTabSelectedCards =
      SelectedCards.fromList(tabsInfo.midleTabInfo?.cards ?? []);
  final ValueNotifier<int?> rightTabSelectedOption = ValueNotifier(null);
  final ValueNotifier<int> selectedTab = ValueNotifier(0);

  String? getButtonText() => tabsInfo.getConfirmButtonText?.call(UserActionInfo(
        tabIndex: selectedTab.value,
        leftTabCards: leftTabSelectedCards.selectedCardModels,
        midleTabCards: midleTabSelectedCards.selectedCardModels,
        rightTabCards: rightTabSelectedCards.selectedCardModels,
        optionIndx: rightTabSelectedOption.value,
      ));

  Widget _listenableBuilder(builder) => ListenableBuilder(
        listenable: selectedTab,
        builder: (BuildContext context, Widget? child) => ListenableBuilder(
          listenable: rightTabSelectedCards,
          builder: (BuildContext context, Widget? child) => ListenableBuilder(
            listenable: leftTabSelectedCards,
            builder: (BuildContext context, Widget? child) => ListenableBuilder(
                listenable: rightTabSelectedOption,
                builder: (BuildContext context, Widget? child) =>
                    ListenableBuilder(
                        listenable: midleTabSelectedCards, builder: builder)),
          ),
        ),
      );

  Widget _getButtonView(context) => _listenableBuilder((BuildContext context,
          Widget? child) =>
      tabsInfo.getConfirmButtonText == null
          ? SizedBox.shrink()
          : getButtonText() == null
              ? SizedBox.shrink()
              : ButtonWithPayment(
                  color: tabsInfo.playerColor.toColor(true),
                  context: context,
                  paymentInfo: tabsInfo.getPaymentInfo?.call(UserActionInfo(
                    tabIndex: selectedTab.value,
                    leftTabCards: leftTabSelectedCards.selectedCardModels,
                    midleTabCards: midleTabSelectedCards.selectedCardModels,
                    rightTabCards: rightTabSelectedCards.selectedCardModels,
                  )),
                  confirmButtonFn: (Payment? payment) {
                    var getOnConfirmButtonFn = tabsInfo.getOnConfirmButtonFn;
                    if (getOnConfirmButtonFn != null) {
                      var onConfirmFn = getOnConfirmButtonFn(UserActionInfo(
                        tabIndex: selectedTab.value,
                        leftTabCards: leftTabSelectedCards.selectedCardModels,
                        midleTabCards: midleTabSelectedCards.selectedCardModels,
                        rightTabCards: rightTabSelectedCards.selectedCardModels,
                        payment: payment,
                        optionIndx: rightTabSelectedOption.value,
                      ));
                      if (onConfirmFn != null) onConfirmFn();
                    }
                    PopupsRegistr.closePopup("showPopupWithTabs");
                  },
                  counters:
                      tabsInfo.getMegacreditsCounters?.call(UserActionInfo(
                    tabIndex: selectedTab.value,
                    leftTabCards: leftTabSelectedCards.selectedCardModels,
                    midleTabCards: midleTabSelectedCards.selectedCardModels,
                    rightTabCards: rightTabSelectedCards.selectedCardModels,
                  )),
                  buttonLabel: getButtonText()!,
                ));

  Widget _getContainerWithTabs(BoxConstraints constraints) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: topPadding < bottomPadding ? bottomPadding - topPadding : 0,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: tabsInfo.useEmptyTabView ?? false
                  ? (tabsInfo.rightTabInfo?.tabTitle.length ?? 30) * 12 + 20
                  : tabsInfo.onlyOneTabWithOptions
                      ? max(
                          (tabsInfo.rightTabInfo?.options?.fold<int>(
                                              0,
                                              (acc, option) => max(
                                                  acc, option.title.length)) ??
                                          1)
                                      .toDouble() *
                                  10 +
                              100,
                          400)
                      : constraints.maxWidth * 0.8,
              height: tabsInfo.useEmptyTabView ?? false
                  ? 70
                  : tabsInfo.onlyOneTabWithOptions
                      ? (tabsInfo.rightTabInfo?.options?.length ?? 1) * 50 + 70
                      : constraints.maxHeight - topPadding - bottomPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(96, 255, 255, 255),
              ),
              child: ContainerWithTabs(
                tabsInfo: tabsInfo,
                selectedTab: selectedTab,
                leftTabSelectedCards: leftTabSelectedCards,
                rightTabSelectedCards: rightTabSelectedCards,
                midleTabSelectedCards: midleTabSelectedCards,
                rightTabSelectedOption: rightTabSelectedOption,
              ),
            ),
            _getButtonView(context),
          ]),
    );
  }

  showDialog(
      barrierColor: Colors.black54,
      context: context,
      builder: (BuildContext context) {
        PopupsRegistr.registerPopupDisposer(
            "showPopupWithTabs", () => Navigator.of(context).pop());
        return Disposer(
          dispose: () {
            rightTabSelectedCards.dispose();
            leftTabSelectedCards.dispose();
            midleTabSelectedCards.dispose();
            selectedTab.dispose();
            rightTabSelectedOption.dispose();
          },
          child: LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              return _getContainerWithTabs(constraints);
            },
          ),
        );
      });
}
