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
import 'package:mars_flutter/domain/model/game_models/CardModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/domain/model/logs/LogMessage.dart';
import 'package:mars_flutter/domain/model/logs/LogMessageDataType.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_name.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/show_popup_with_tabs.dart';

class LogsView extends StatelessWidget {
  //final ScrollController scrollController;
  final LogsCubit logsCubit;
  final ScrollController scrollController = new ScrollController();

  LogsView({
    // required this.scrollController,
    required this.logsCubit,
  });

  Widget _buildLog(LogMessage logMessage, playersNames, context) {
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
//проверить что количество плейсхолдеров меньше чем количество данных и остаток (если это карты) показывать в попапе при клике на строку
    String message = logMessage.message;
    List<CardName> popupCards = [];

    for (var i = 0; i < logMessage.data.length; i++) {
      if (message.indexOf("\${${i}}") == -1) {
        if (logMessage.data[i].type == LogMessageDataType.CARD) {
          popupCards.add(CardName.fromString(logMessage.data[i].value));
        }
      } else {
        final String textPart =
            message.substring(0, message.indexOf("\${${i}}"));
        message = message.substring(message.indexOf("\${${i}}") + 4);

        if (textPart.length > 0) messageViews.add(createTextView(textPart));
        switch (logMessage.data[i].type) {
          case LogMessageDataType.PLAYER:
            final PlayerColor playerColor =
                PlayerColor.fromString(logMessage.data[i].value) ??
                    PlayerColor.NEUTRAL;
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
    }
    if (message.length > 0) messageViews.add(createTextView(message));
    final addOnClickIfPopupNeeded = (Widget child) => popupCards.length > 0
        ? InkWell(
            onTap: () => showPopupWithTabs(
              context: context,
              tabsInfo: PresentationTabsInfo(
                playerColor: PlayerColor.NEUTRAL,
                rightTabInfo: PresentationTabInfo(
                  tabTitle: "Discarded cards",
                  cards:
                      popupCards.map((name) => CardModel(name: name)).toList(),
                ),
              ),
              topPadding: 100.0,
              bottomPadding: 100.0,
            ),
            child: child,
          )
        : child;
    return addOnClickIfPopupNeeded(Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Wrap(
        runSpacing: 1.0,
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.spaceEvenly,
        children: messageViews,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogsCubit, LogsState>(
        bloc: logsCubit,
        builder: (context, state) {
          Timer(
            Duration(milliseconds: 500),
            () => scrollController.animateTo(
              scrollController.position.maxScrollExtent + 1000,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            ),
          );
          logger.d("Debug: $state");
          return GameOptionContainer(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
              child: ListView(
                controller: scrollController,
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
                                    initiallyExpanded: state.logs
                                            ?.logsByGenerations.keys.last ==
                                        key,
                                    children: value
                                        .map((message) => _buildLog(message,
                                            state.logs?.playersNames, context))
                                        .toList(),
                                  )),
                            )
                            .values
                            .toList() ??
                        [],
              ));
        });
  }
}
