import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/payment_view/payment_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/selected_cards_model.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/tabs/container_with_tabs.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:tab_container/tab_container.dart';

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
  final TabContainerController tabController = TabContainerController(
    length: tabsInfo.leftTabInfo?.cards == null &&
            tabsInfo.leftTabInfo?.disabledCards == null
        ? tabsInfo.midleTabInfo?.cards == null &&
                tabsInfo.midleTabInfo?.disabledCards == null
            ? 1
            : 2
        : tabsInfo.midleTabInfo?.cards == null &&
                tabsInfo.midleTabInfo?.disabledCards == null
            ? 2
            : 3,
  );

  String? getButtonText() => tabsInfo.getConfirmButtonText?.call(UserActionInfo(
        tabIndex: tabController.index,
        leftTabCards: leftTabSelectedCards.selectedCardModels,
        midleTabCards: midleTabSelectedCards.selectedCardModels,
        rightTabCards: rightTabSelectedCards.selectedCardModels,
        optionIndx: rightTabSelectedOption.value,
      ));

  Widget _listenableBuilder(builder) => ListenableBuilder(
        listenable: tabController,
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
                    tabIndex: tabController.index,
                    leftTabCards: leftTabSelectedCards.selectedCardModels,
                    midleTabCards: midleTabSelectedCards.selectedCardModels,
                    rightTabCards: rightTabSelectedCards.selectedCardModels,
                  )),
                  confirmButtonFn: (Payment? payment) {
                    var getOnConfirmButtonFn = tabsInfo.getOnConfirmButtonFn;
                    if (getOnConfirmButtonFn != null) {
                      var onConfirmFn = getOnConfirmButtonFn(UserActionInfo(
                        tabIndex: tabController.index,
                        leftTabCards: leftTabSelectedCards.selectedCardModels,
                        midleTabCards: midleTabSelectedCards.selectedCardModels,
                        rightTabCards: rightTabSelectedCards.selectedCardModels,
                        payment: payment,
                        optionIndx: rightTabSelectedOption.value,
                      ));
                      if (onConfirmFn != null) onConfirmFn();
                    }
                    Navigator.of(context).pop();
                  },
                  counters:
                      tabsInfo.getMegacreditsCounters?.call(UserActionInfo(
                    tabIndex: tabController.index,
                    leftTabCards: leftTabSelectedCards.selectedCardModels,
                    midleTabCards: midleTabSelectedCards.selectedCardModels,
                    rightTabCards: rightTabSelectedCards.selectedCardModels,
                  )),
                  buttonLabel: getButtonText()!,
                ));

  Widget _getContainerWithTabs(BoxConstraints constraints) {
    final bool onlyOneTabWithOptions = tabsInfo.rightTabInfo?.options != null &&
        tabsInfo.midleTabInfo?.options == null &&
        tabsInfo.leftTabInfo?.options == null &&
        tabsInfo.rightTabInfo?.cards == null &&
        tabsInfo.midleTabInfo?.cards == null &&
        tabsInfo.leftTabInfo?.cards == null &&
        tabsInfo.rightTabInfo?.disabledCards == null &&
        tabsInfo.midleTabInfo?.disabledCards == null &&
        tabsInfo.leftTabInfo?.disabledCards == null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: topPadding < bottomPadding ? bottomPadding - topPadding : 0,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: onlyOneTabWithOptions
                  ? max(
                      (tabsInfo.rightTabInfo?.options?.fold<int>(
                                          0,
                                          (acc, option) =>
                                              max(acc, option.title.length)) ??
                                      1)
                                  .toDouble() *
                              10 +
                          100,
                      400)
                  : constraints.maxWidth * 0.8,
              height: onlyOneTabWithOptions
                  ? (tabsInfo.rightTabInfo?.options?.length ?? 1) * 50 + 70
                  : constraints.maxHeight - topPadding - bottomPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(96, 255, 255, 255),
              ),
              child: ContainerWithTabs(
                tabsInfo: tabsInfo,
                tabController: tabController,
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
        return Disposer(
          dispose: () {
            rightTabSelectedCards.dispose();
            leftTabSelectedCards.dispose();
            midleTabSelectedCards.dispose();
            tabController.dispose();
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
