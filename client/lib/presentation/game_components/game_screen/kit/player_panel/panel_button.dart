import 'dart:async';

import 'package:flutter/material.dart';

enum PanelButtonBorder {
  LEFT,
  RIGHT,
  FULL,
}

class PanelButton extends StatelessWidget {
  final PanelButtonBorder panelButtonBorder;
  final void Function()? onClick;
  final String? buttonText;
  final String? tooltipText;
  final bool? callOnClickAutomatically;
  final Widget? child;

  const PanelButton({
    required this.panelButtonBorder,
    this.onClick,
    this.buttonText,
    this.tooltipText,
    this.callOnClickAutomatically,
    this.child,
  });

  Widget _prepareButtonView2(BuildContext context) {
    const double borderRadius = 7;
    return MaterialButton(
      hoverColor: Colors.grey[400],
      onPressed: onClick,
      minWidth: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: switch (panelButtonBorder) {
          PanelButtonBorder.LEFT => BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
            ),
          PanelButtonBorder.RIGHT => BorderRadius.only(
              topRight: Radius.circular(borderRadius),
            ),
          PanelButtonBorder.FULL => BorderRadius.only(
              topRight: Radius.circular(borderRadius),
              topLeft: Radius.circular(borderRadius),
            ),
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: child ??
          Text(
            buttonText ?? " ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //without this timer popup will crash app. Looks like it happen because context is not ready yet
    if ((callOnClickAutomatically ?? false) && onClick != null) {
      Timer(Duration(milliseconds: 30), () {
        onClick!();
      });
    }
    return _prepareButtonView2(context);
  }
}
