import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_ma_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_parties_info.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/turmoil/delegates_lobby_and_active_party.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/turmoil/global_events_list.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/ma.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/turmoil/parties.dart';
import 'package:tab_container/tab_container.dart';

class TopPanel extends StatefulWidget {
  final ParticipantId participantId;
  final PresentationMaInfo awardsInfo;
  final PresentationMaInfo milestonesInfo;
  final PresentationTurmoilInfo? turmoilInfo;
  final PlayerColor playerColor;
  const TopPanel({
    required this.awardsInfo,
    required this.milestonesInfo,
    required this.playerColor,
    this.turmoilInfo,
    required this.participantId,
  });

  @override
  State<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> with TickerProviderStateMixin {
  final selectedTab = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    final elementWidth = 120.0;
    final elementHeight = 80.0;
    final tabCount = widget.turmoilInfo != null ? 3 : 2;
    selectedTab.value = min(
        tabCount - 1,
        int.parse(
          localStorage
                  .getItem("selectedTab_${widget.participantId.toString()}") ??
              selectedTab.value.toString(),
        ));
    final width = widget.turmoilInfo != null
        ? widget.turmoilInfo!.turmoilModel.parties.length * 120.0 * 1.15
        : widget.awardsInfo.ma.length * 120.0;
    final controller = TabController(
      length: tabCount,
      vsync: this,
      initialIndex: selectedTab.value,
    );
    controller.addListener(() {
      selectedTab.value = controller.index;
      localStorage.setItem("selectedTab_${widget.participantId.toString()}",
          controller.index.toString());
    });

    return ConstrainedBox(
      constraints: BoxConstraints(),
      //maxHeight: maxHeight, maxWidth: awardsInfo.ma.length * 140.0),
      child: TabContainer(
        tabExtent: 30.0,
        tabEdge: TabEdge.top,
        color: Colors.black,
        controller: controller,
        children: [
          MaView(
            presentationInfo: widget.milestonesInfo,
            elementWidth: elementWidth,
            elementHeight: elementHeight,
            playerColor: widget.playerColor,
            width: width,
          ),
          MaView(
            presentationInfo: widget.awardsInfo,
            elementWidth: elementWidth,
            elementHeight: elementHeight,
            playerColor: widget.playerColor,
            width: width,
          ),
          if (widget.turmoilInfo != null)
            ListenableBuilder(
              listenable: selectedTab,
              builder: (context, child) => Column(spacing: 5.0, children: [
                selectedTab.value == 2
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                            DelegatesLobbyAndActiveParty(
                              turmoilModel: widget.turmoilInfo!.turmoilModel,
                              onApplyPolicyAction:
                                  widget.turmoilInfo!.onApplyPolicyAction,
                              width: elementWidth * 1.20,
                              height: elementHeight * 1.14,
                            ),
                            GlobalEventsList(
                              turmoilModel: widget.turmoilInfo!.turmoilModel,
                            )
                          ])
                    : SizedBox.shrink(),
                child!,
              ]),
              child: PartyLineView(
                presentationInfo: widget.turmoilInfo!,
                width: elementWidth * 1.15,
                height: elementHeight,
                playerColor: widget.playerColor,
              ),
            ),
        ],
        tabs: [
          Text("Milestones"),
          Text("Awards"),
          if (widget.turmoilInfo != null) Text("Turmoil"),
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
