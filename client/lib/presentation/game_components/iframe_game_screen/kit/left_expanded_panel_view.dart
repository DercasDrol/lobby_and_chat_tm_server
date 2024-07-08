import 'package:flutter/material.dart';

class LeftExpandedPanelForIframeGameClient extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Widget connectionIndicator;
  final void Function() onExpandClick;
  final bool expanded;
  final double buttonWidth;
  final int counter;
  final double goToLobbyButtonHeight;
  final Widget menuButtonsBlock;
  const LeftExpandedPanelForIframeGameClient({
    required this.width,
    required this.onExpandClick,
    required this.height,
    required this.child,
    required this.buttonWidth,
    required this.expanded,
    required this.counter,
    required this.goToLobbyButtonHeight,
    required this.connectionIndicator,
    required this.menuButtonsBlock,
  });

  Widget build(BuildContext context) {
    final expandButton = TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (counter > 0 && !expanded)
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(5),
              child: Text(
                "!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            expanded ? "<" : ">",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
      onPressed: onExpandClick,
    );
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        menuButtonsBlock,
        child,
      ]),
      Container(
        width: buttonWidth,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[900],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: connectionIndicator,
            ),
            Container(
              height: height - 20,
              child: expandButton,
            )
          ],
        ),
      )
    ]);
  }
}
