import 'package:mars_flutter/data/api/auth/auth_api_client.dart';
import 'package:mars_flutter/data/api/chat/chat_api_client.dart';
import 'package:mars_flutter/data/api/game/game_api_client.dart';
import 'package:mars_flutter/data/api/lobby/lobby_api_client.dart';

class Repositories {
  late final AuthAPIClient auth;
  late final ChatAPIClient chat;
  late final LobbyAPIClient lobby;
  final GameAPIClient game = GameAPIClient();

  Repositories() {
    auth = AuthAPIClient();
    chat = ChatAPIClient(auth.jwt);
    lobby = LobbyAPIClient(auth.jwt);
  }
}
