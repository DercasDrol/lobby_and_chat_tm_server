import 'package:mars_flutter/data/api/auth/auth_api_client.dart';
import 'package:mars_flutter/data/api/chat/chat_api_client.dart';
import 'package:mars_flutter/data/api/game/game_api_client.dart';
import 'package:mars_flutter/data/api/lobby/lobby_api_client.dart';

class Repositories {
  static final AuthAPIClient auth = AuthAPIClient();
  static final ChatAPIClient chat = ChatAPIClient(auth.jwt);
  static final LobbyAPIClient lobby = LobbyAPIClient(auth.jwt);
  static final GameAPIClient game = GameAPIClient(host: auth.gameServer);
}
