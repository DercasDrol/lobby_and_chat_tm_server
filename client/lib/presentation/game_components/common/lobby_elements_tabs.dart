import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

class LobbyElementsTabs extends StatelessWidget {
  final double width;
  final double height;
  final TabContainerController? controller;
  final List<Widget> children;
  final List<String> tabsNames;
  final BorderRadius? borderRadius;

  const LobbyElementsTabs({
    super.key,
    required this.width,
    required this.height,
    required this.children,
    required this.tabsNames,
    this.controller,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(10)),
      ),
      child: TabContainer(
        key: UniqueKey(),
        controller: controller,
        color: Colors.grey[700],
        enabled: true,
        //childPadding: EdgeInsets.all(5.0),
        children: children,
        tabs: tabsNames,
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w500,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 1,
            ),
          ],
        ),
        unselectedTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
