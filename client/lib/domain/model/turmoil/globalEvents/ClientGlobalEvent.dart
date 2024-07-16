import 'dart:async';

import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/domain/model/card/render/ICardRenderDescription.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';
import 'package:mars_flutter/domain/model/turmoil/globalEvents/GlobalEventName.dart';

class ClientGlobalEvent {
  final GameModule module;
  final GlobalEventName name;
  final ICardRenderDescription description;
  final PartyName revealedDelegate;
  final PartyName currentDelegate;
  final CardComponent renderData;

  ClientGlobalEvent({
    required this.module,
    required this.name,
    required this.description,
    required this.revealedDelegate,
    required this.currentDelegate,
    required this.renderData,
  });

  factory ClientGlobalEvent.fromJson(Map<String, dynamic> json) {
    return ClientGlobalEvent(
      module: GameModule.fromString(json['module']),
      name: GlobalEventName.fromString(json['name']),
      description: ICardRenderDescription(
          text: json['description'],
          align: DescriptionAlign.CENTER,
          sizeMultiplicator: 0.8),
      revealedDelegate: PartyName.fromString(json['revealedDelegate']),
      currentDelegate: PartyName.fromString(json['currentDelegate']),
      renderData: CardComponent.fromJson(json['renderData']),
    );
  }

  static final Completer<Map<GlobalEventName, ClientGlobalEvent>> _completer =
      new Completer();
  static Map<GlobalEventName, ClientGlobalEvent> _clientEvents = Map();
  static Future<Map<GlobalEventName, ClientGlobalEvent>> get allEvents =>
      _completer.future;
  static setAllEvents(List<ClientGlobalEvent> value) {
    _clientEvents = Map.fromIterable(
      value,
      key: (card) => (card as ClientGlobalEvent).name,
      value: (card) => card,
    );
    _completer.complete(_clientEvents);
  }

  factory ClientGlobalEvent.fromEventName(GlobalEventName eventName) {
    return _clientEvents[eventName]!;
  }
}
