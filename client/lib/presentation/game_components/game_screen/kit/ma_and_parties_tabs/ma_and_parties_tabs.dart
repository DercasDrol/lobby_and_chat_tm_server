import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_ma_info.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/ma.dart';
import 'package:tab_container/tab_container.dart';

class MaAndPartiesTabs extends StatelessWidget {
  final PresentationMaInfo awardsInfo;
  final PresentationMaInfo milestonesInfo;
  final Color playerColor;
  final double maxHeight;
  const MaAndPartiesTabs({
    required this.awardsInfo,
    required this.milestonesInfo,
    required this.playerColor,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: maxHeight, maxWidth: awardsInfo.ma.length * 140.0),
      child: TabContainer(
        tabExtent: 90.0,
        childPadding: EdgeInsets.all(5.0),
        tabEdge: TabEdge.left,
        children: [
          MaView(
            presentationInfo: milestonesInfo,
            width: 120.0,
            height: 80.0,
            playerColor: playerColor,
          ),
          MaView(
            presentationInfo: awardsInfo,
            width: 120.0,
            height: 80.0,
            playerColor: playerColor,
          ),
        ],
        tabs: [
          Text("Milestones"),
          Text("Awards"),
        ],
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
        unselectedTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
