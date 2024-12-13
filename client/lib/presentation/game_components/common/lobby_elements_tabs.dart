import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return OverflowBox(
        minWidth: 0,
        minHeight: widget.height,
        maxWidth: widget.width,
        maxHeight: widget.height,
        alignment: Alignment.centerLeft,
        fit: OverflowBoxFit.deferToChild,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey[800],
          ),
          child: TabContainer(
            //key: UniqueKey(),
            controller: controller,
            color: Colors.grey[700],
            borderRadius: BorderRadius.zero,
            tabBorderRadius: BorderRadius.zero,
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
        ));
  }
}
