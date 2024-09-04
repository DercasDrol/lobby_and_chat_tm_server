import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/turmoil/globalEvents/ClientGlobalEvent.dart';
import 'package:mars_flutter/presentation/core/on_hover.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/card_body.dart';

const double EVENT_WIDTH = 332;
const double EVENT_HEIGHT = 186;
const double EVENT_WIDTH_MINI = 166;
const double EVENT_HEIGHT_MINI = 93;

class EventView extends StatelessWidget {
  EventView({
    required this.event,
    this.sizeRatio,
    this.useMiniSize,
  });

  final double _zoomedCardSizeRatio = 1.2;
  final ClientGlobalEvent event;
  final double? sizeRatio;
  final bool? useMiniSize;
  get width => useMiniSize == true ? EVENT_WIDTH_MINI : EVENT_WIDTH;
  get height => useMiniSize == true ? EVENT_HEIGHT_MINI : EVENT_HEIGHT;

  @override
  Widget build(BuildContext context) {
    final double cadr_width = width * (sizeRatio ?? 1);
    final double card_height = height * (sizeRatio ?? 1);
    final double partyIconWidth = width * 0.16 * (sizeRatio ?? 1);
    Widget _getEventView() {
      final background = Image.asset(Assets.parties.globalEvent2.path,
          width: cadr_width, height: card_height);
      final leftPartyIcon = Align(
        alignment: Alignment.bottomLeft,
        child: event.revealedDelegate.toImagePath() != null
            ? Padding(
                padding: EdgeInsets.all(card_height * 0.03),
                child: Image.asset(
                  event.revealedDelegate.toImagePath()!,
                  width: partyIconWidth,
                ))
            : SizedBox.shrink(),
      );
      final rightPartyIcon = Align(
        alignment: Alignment.bottomRight,
        child: event.currentDelegate.toImagePath() != null
            ? Padding(
                padding: EdgeInsets.all(card_height * 0.03),
                child: Image.asset(event.currentDelegate.toImagePath()!,
                    width: partyIconWidth),
              )
            : SizedBox.shrink(),
      );
      final eventName = Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: cadr_width - partyIconWidth * 2 - cadr_width * 0.08,
          height: card_height * 0.25,
          alignment: Alignment.center,
          child: FittedBox(
              child: Text(
            event.name.toString().toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      );
      final cardBody = Padding(
        padding: EdgeInsets.only(
            top: card_height * 0.05, bottom: card_height * 0.25),
        child: Align(
          alignment: Alignment.center,
          child: CardBody(
            renderData: event.renderData,
            elementsSizeMultiplicator: (useMiniSize ?? false) ? 2.3 : 1.6,
            height: card_height - (card_height * 0.35),
            width: cadr_width * ((useMiniSize ?? false) ? 0.95 : 0.90),
            description: (useMiniSize ?? false) ? null : event.description,
          ),
        ),
      );

      return Stack(
        children: [
          background,
          cardBody,
          eventName,
          leftPartyIcon,
          rightPartyIcon,
        ],
      );
    }

    return (useMiniSize ?? false)
        ? SizedBox(
            width: EVENT_WIDTH_MINI,
            height: EVENT_HEIGHT_MINI,
            child: JustTheTooltip(
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              waitDuration: Duration(milliseconds: 100),
              tailLength: 0.0,
              tailBaseWidth: 0.0,
              offset: -0.0,
              margin: EdgeInsets.all(0.0),
              content: SizedBox(
                  width: EVENT_WIDTH,
                  height: EVENT_HEIGHT,
                  child: EventView(
                    event: event,
                    sizeRatio: 1.0,
                  )),
              child: _getEventView(),
            ))
        : sizeRatio == null
            ? OnHoverZoom(
                width: cadr_width,
                height: card_height,
                ratio: _zoomedCardSizeRatio,
                child: _getEventView(),
              )
            : _getEventView();
  }
}
