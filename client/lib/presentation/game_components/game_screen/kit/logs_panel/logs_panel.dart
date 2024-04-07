import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/logs_cubit.dart';
import 'package:mars_flutter/domain/logs_state.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/logs/LogMessage.dart';
import 'package:mars_flutter/domain/model/logs/LogMessageDataType.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_name.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class LogsPanel extends StatefulWidget {
  final LogsCubit logsCubit;
  final double topPadding;
  final double bottomPadding;

  const LogsPanel({
    required this.logsCubit,
    required this.topPadding,
    required this.bottomPadding,
  });
  @override
  State<LogsPanel> createState() {
    logger.d("Debug: LogsPanel createState()");
    return _LogsPanelState();
  }
}

class _LogsPanelState extends State<LogsPanel> {
  _LogsPanelState();
  bool collapsed = false;
  final _color = Colors.white;
  Widget _buildLog(LogMessage logMessage, playersNames) {
    List<Widget> messageViews = [
      Tooltip(
        message: DateTime.fromMillisecondsSinceEpoch(logMessage.timestamp)
            .toLocal()
            .toString()
            .substring(0, 19),
        child: Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(
            Icons.timer,
            color: Colors.white,
          ),
        ),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      )
    ];
    createTextView(String text) => Text(
          text,
          style: TextStyle(color: Colors.white),
        );

    String message = logMessage.message;
    for (var i = 0; i < logMessage.data.length; i++) {
      final String texpPart = message.substring(0, message.indexOf("\${${i}}"));
      message = message.substring(message.indexOf("\${${i}}") + 4);

      if (texpPart.length > 0) messageViews.add(createTextView(texpPart));
      switch (logMessage.data[i].type) {
        case LogMessageDataType.PLAYER:
          final PlayerColor playerColor =
              PlayerColor.fromString(logMessage.data[i].value);
          messageViews.add(
            Container(
              padding: EdgeInsets.only(bottom: 2, left: 5, right: 5),
              decoration: BoxDecoration(
                color: playerColor.toColor(true),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                playersNames[playerColor] ?? logMessage.data[i].value,
                textAlign: TextAlign.center,
                style: MAIN_TEXT_STYLE,
              ),
            ),
          );
          break;
        case LogMessageDataType.CARD:
          final CardName cardName =
              CardName.fromString(logMessage.data[i].value);
          ClientCard card = ClientCard.fromCardName(cardName);
          messageViews.add(JustTheTooltip(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            waitDuration: Duration(milliseconds: 100),
            content: SizedBox(
              width: CARD_WIDTH * 1.1,
              height: CARD_HEIGHT * 1.1,
              child: CardView(
                sizeRatio: 1.1,
                card: card,
                isDeactivated: false,
                isSelected: false,
              ),
            ),
            child: CardNameView(
              name: card.name,
              type: card.type,
              height: 20.0,
            ),
          ));
          break;
        default:
          messageViews.add(createTextView(logMessage.data[i].value));
      }
    }
    if (message.length > 0) messageViews.add(createTextView(message));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Wrap(
        runSpacing: 1.0,
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.spaceEvenly,
        children: messageViews,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Debug: LogsPanel build()");
    final double width = 450;
    final double buttonWidth = 20;
    final ScrollController _scrollController = new ScrollController();
    final _preparedList = BlocBuilder<LogsCubit, LogsState>(
        bloc: widget.logsCubit,
        builder: (context, state) {
          logger.d("Debug: $state");
          return ListView(
            controller: _scrollController,
            children: state.logs == null
                ? [Center(child: CircularProgressIndicator())]
                : state.logs?.logsByGenerations
                        .map(
                          (key, value) => MapEntry(
                              key,
                              ExpansionTile(
                                expandedAlignment: Alignment.centerLeft,
                                title: Text("Generation ${key}"),
                                textColor: Colors.white,
                                collapsedTextColor: Colors.grey,
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.grey,
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                initiallyExpanded:
                                    state.logs?.logsByGenerations.keys.last ==
                                        key,
                                children: value
                                    .map((message) => _buildLog(
                                        message, state.logs?.playersNames))
                                    .toList(),
                              )),
                        )
                        .values
                        .toList() ??
                    [],
          );
        });

    Timer(
      Duration(milliseconds: 500),
      () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 1000,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      ),
    );
    return LayoutBuilder(
      builder: (context, constrain) => AnimatedSlide(
        offset: Offset(collapsed ? 0.0 : -(width - buttonWidth + 1) / width, 0),
        duration: Duration(milliseconds: 500),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: widget.bottomPadding,
            top: widget.topPadding,
          ),
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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.grey[900],
                ),
                child: _preparedList,
              ),
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
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
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
