import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/game_button_with_cost.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/payment_view/payment_changer.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/payment_view/selected_payment_model.dart';

class ButtonWithPayment extends StatelessWidget {
  final BuildContext context;
  final Color color;
  final PaymentInfo? paymentInfo;
  final List<MegacreditsCounter>? counters;
  final String buttonLabel;
  final Function(Payment?)? confirmButtonFn;

  ButtonWithPayment({
    required this.context,
    this.paymentInfo,
    required this.buttonLabel,
    this.confirmButtonFn,
    this.counters,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    SelectedPayment? selectedPayment = paymentInfo == null
        ? null
        : SelectedPayment.fromPaymentInfo(paymentInfo!);
    final BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      border: Border(
        top: BorderSide.none,
      ),
      color: color,
    );
    return Disposer(
      dispose: () {
        selectedPayment?.dispose();
      },
      child: ListenableBuilder(
        listenable: selectedPayment ?? ValueNotifier(null),
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: max(
                      50 +
                          buttonLabel.length * 9.5 +
                          ((selectedPayment?.currentSum ?? counters) == null
                              ? 0
                              : 40),
                      selectedPayment?.presentationInfos != null ? 160.0 : 0),
                  decoration: boxDecoration,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...(counters == null
                          ? []
                          : counters!.fold(
                              [],
                              (acc, mkCounter) => mkCounter.counterLable != null
                                  ? [
                                      ...acc,
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                    mkCounter.counterLable!,
                                                    textAlign: TextAlign.center,
                                                    style: MAIN_TEXT_STYLE
                                                        .copyWith(
                                                      fontSize: 20,
                                                    ))),
                                            CostView(
                                              cost: mkCounter.counter,
                                              width: 30.0,
                                              height: 30.0,
                                              multiplier: false,
                                              useGreyMode: false,
                                            )
                                          ])
                                    ]
                                  : acc,
                            ).toList()),
                      ...selectedPayment?.presentationInfos
                              .map((e) => PaymentChanger(presentationInfo: e))
                              .toList() ??
                          [],
                      Padding(
                        padding: EdgeInsets.only(
                            left: 7.0, right: 7.0, bottom: 7.0, top: 2.0),
                        child: GameButtonWithCost(
                          counter: selectedPayment?.currentSum ??
                              counters?.fold<int?>(
                                  null,
                                  (acc, element) => element.counterLable == null
                                      ? element.counter
                                      : acc),
                          onPressed: (selectedPayment?.correctSum ?? true) &&
                                  confirmButtonFn != null
                              ? () => confirmButtonFn!
                                  .call(selectedPayment?.payment)
                              : null,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 5.0),
                            child: Text(
                              buttonLabel,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
