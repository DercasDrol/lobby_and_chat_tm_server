import 'package:flutter/foundation.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket getNewSocketInstance(final String port) {
  final _socket = IO.io('ws://localhost:$port', <String, dynamic>{
    'transports': kIsWeb ? ['polling', 'websocket'] : ['websocket'],
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
