import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/game_button_with_cost.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/payment_view/selected_payment_model.dart';

class PaymentChanger extends StatelessWidget {
  final PresentationInfo presentationInfo;
  const PaymentChanger({required this.presentationInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 5.0,
          ),
          Image.asset(
            presentationInfo.iconPath,
            width: 30,
            height: 30,
          ),
          SizedBox(
            width: 5.0,
          ),
          GameButtonWithCost(
            onPressed: presentationInfo.onDecreaseButtonFn,
            child: Icon(
              Icons.remove,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 25.0,
            child: Center(
              child: Text(
                presentationInfo.value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  shadows: List.filled(
                      2,
                      Shadow(
                        color: Colors.black,
                        blurRadius: 2,
                      )),
                ),
              ),
            ),
          ),
          GameButtonWithCost(
            onPressed: presentationInfo.onIncreaseButtonFn,
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          GameButtonWithCost(
            onPressed: presentationInfo.onMaxButtonFn,
            child: Text(
              'MAX',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
        ],
      ),
    );
  }
}
