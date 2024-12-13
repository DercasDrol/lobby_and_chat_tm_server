import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';

void showFilterPopup({
  required final BuildContext context,
  required final Widget child,
  required final Function() onApply,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(builder: (context, constraints) {
          return Center(
              child: Container(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.85,
              maxWidth: constraints.maxWidth * 0.80,
            ),
            child: Column(
              children: [
                Container(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight * 0.85 - 30.0,
                      maxWidth: constraints.maxWidth * 0.80,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: child),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 30.0,
                      maxWidth: constraints.maxWidth * 0.80,
                    ),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      BottomButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'CLOSE',
                      ),
                      SizedBox(width: 10.0),
                      BottomButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onApply();
                        },
                        text: 'APPLY',
                      )
                    ]),
                  ),
                )
              ],
            ),
          ));
        });
      });
}
