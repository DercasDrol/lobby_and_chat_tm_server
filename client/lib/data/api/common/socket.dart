import 'package:flutter/foundation.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:html' as html;

IO.Socket getNewSocketInstance(final String port) {
  final host = kIsWeb ? html.window.location.hostname : AUTH_CHAT_LOBBY_HOST;
  final fullUrl =
      host == 'localhost' ? 'ws://localhost:$port' : 'wss://$host:$port';
  final _socket = IO.io(fullUrl, <String, dynamic>{
    'transports': kIsWeb ? ['polling'] : ['websocket'],
    'forceNew': true,
    'autoConnect': false
  });

  _socket.onConnect((_) {
    logger.d('connected to websocket port:$port');
  });

  _socket.onDisconnect((_) {
    logger.d('disconnected from websocket port:$port');
  });

  return _socket;
}
