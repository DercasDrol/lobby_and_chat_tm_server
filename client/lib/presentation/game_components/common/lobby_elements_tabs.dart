import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

class LobbyElementsTabs extends StatefulWidget {
  final double width;
  final double height;
  //final TabContainerController? controller;
  final List<Widget> children;
  final List<String> tabsNames;
  final BorderRadius? borderRadius;

  const LobbyElementsTabs({
    super.key,
    required this.width,
    required this.height,
    required this.children,
    required this.tabsNames,
    //this.controller,
    this.borderRadius,
  });

  @override
  State<LobbyElementsTabs> createState() => _LobbyElementsTabsState();
}

class _LobbyElementsTabsState extends State<LobbyElementsTabs>
    with TickerProviderStateMixin {
  final selectedTab = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    final controller = TabController(
      length: widget.children.length,
      vsync: this,
      initialIndex: selectedTab.value,
    );
    controller.addListener(() {
      selectedTab.value = controller.index;
    });
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius:
            widget.borderRadius ?? BorderRadius.all(Radius.circular(10)),
      ),
      child: TabContainer(
        //key: UniqueKey(),
        controller: controller,
        color: Colors.grey[700],
        enabled: true,
        //childPadding: EdgeInsets.all(5.0),
        children: widget.children,
        tabs: widget.tabsNames.map((e) => Text(e)).toList(),
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
