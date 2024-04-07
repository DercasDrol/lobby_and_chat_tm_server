import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';

class GameButtonWithCost extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final int? counter;

  const GameButtonWithCost({
    super.key,
    required this.child,
    required this.onPressed,
    this.counter,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...counter != null
            ? [
                CostView(
                  cost: counter!,
                  width: iconSize,
                  height: iconSize,
                  fontSize: iconSize * 0.65,
                  multiplier: false,
                  useGreyMode: false,
                ),
                SizedBox(
                  width: 10.0,
                ),
              ]
            : [],
        MaterialButton(
          onPressed: onPressed,
          color: Colors.white,
          disabledColor: Colors.grey[600],
          hoverColor: Colors.grey[400],
          minWidth: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 9.0),
          child: child,
        )
      ],
    );
  }
}
