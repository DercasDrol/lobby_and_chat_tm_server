import 'package:flutter/material.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/logs_cubit.dart';
import 'package:mars_flutter/presentation/game_components/common/game_menu_buttons_block.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/left_expanded_panel/kit/chat_and_logs_view.dart';

class LeftExpandedPanel extends StatefulWidget {
  final LogsCubit logsCubit;
  final LobbyCubit lobbyCubit;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  final double topPadding;
  final double bottomPadding;

  const LeftExpandedPanel({
    required this.logsCubit,
    required this.topPadding,
    required this.bottomPadding,
    required this.gameChatCubit,
    required this.generalChatCubit,
    required this.lobbyCubit,
  });
  @override
  State<LeftExpandedPanel> createState() {
    logger.d("Debug: LogsPanel createState()");
    return _LeftExpandedPanelState();
  }
}

class _LeftExpandedPanelState extends State<LeftExpandedPanel> {
  _LeftExpandedPanelState();
  bool collapsed = false;
  final _color = Colors.white;
  @override
  Widget build(BuildContext context) {
    logger.d("Debug: LogsPanel build()");
    final double width = 450;
    final double buttonWidth = 20;
    const goToLobbyButtonHeight = 30.0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding,
        top: widget.topPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constrain) => AnimatedSlide(
          offset:
              Offset(collapsed ? 0.0 : -(width - buttonWidth + 1) / width, 0),
          duration: Duration(milliseconds: 500),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: EdgeInsets.only(top: 1, bottom: 1, right: 1),
              width: width,
              height: constrain.maxHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: _color,
              ),
              child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.grey[900],
                  ),
                  child: Column(children: [
                    GameMenuButtonsBlock(
                      lobbyCubit: widget.lobbyCubit,
                      width: width,
                      height: goToLobbyButtonHeight,
                    ),
                    ChatAndLogsTabsView(
                      gameChatCubit: widget.gameChatCubit,
                      generalChatCubit: widget.generalChatCubit,
                      width: width,
                      height: constrain.maxHeight - goToLobbyButtonHeight - 12,
                      logsCubit: widget.logsCubit,
                      //scrollController: _scrollController,
                    ),
                  ])),
            ),
            Container(
              width: 20,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: _color,
              ),
              child: TextButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                child: Text(
                  collapsed ? "<" : ">",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    collapsed = !collapsed;
                  });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
