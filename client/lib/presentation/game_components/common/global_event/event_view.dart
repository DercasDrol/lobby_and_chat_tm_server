import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/turmoil/globalEvents/ClientGlobalEvent.dart';
import 'package:mars_flutter/presentation/core/on_hover.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/card_body.dart';

const double EVENT_WIDTH = 332;
const double EVENT_HEIGHT = 186;

class EventView extends StatelessWidget {
  EventView({
    required this.event,
    this.sizeRatio,
  });

  final double _zoomedCardSizeRatio = 1.2;
  final ClientGlobalEvent event;
  final double? sizeRatio;

  @override
  Widget build(BuildContext context) {
    final double cadr_width = EVENT_WIDTH * (sizeRatio ?? 1);
    final double card_height = EVENT_HEIGHT * (sizeRatio ?? 1);
    final double partyIconWidth = EVENT_WIDTH * 0.16 * (sizeRatio ?? 1);
    Widget _getEventView() {
      final background = Image.asset(Assets.parties.globalEvent2.path);
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
          child: Text(
            event.name.toString().toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      final cardBody = Padding(
        padding: EdgeInsets.only(
            top: card_height * 0.05, bottom: card_height * 0.25),
        child: Align(
          alignment: Alignment.center,
          child: CardBody(
            renderData: event.renderData,
            elementsSizeMultiplicator: 1.6,
            height: card_height - (card_height * 0.35),
            width: cadr_width * 0.90,
            description: event.description,
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

    return sizeRatio == null
        ? OnHoverZoom(
            width: cadr_width,
            height: card_height,
            ratio: _zoomedCardSizeRatio,
            builder: (isHovered) => _getEventView(),
          )
        : _getEventView();
  }
}
