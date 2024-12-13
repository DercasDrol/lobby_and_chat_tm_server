import 'package:flutter/material.dart';
import 'package:mars_flutter/data/api/chat/chat_api_client.dart';
import 'package:mars_flutter/data/api/lobby/lobby_api_client.dart';

class ConnectionIndicator extends StatelessWidget {
  final LobbyAPIClient lobbyRepository;
  final ChatAPIClient chatRepository;
  const ConnectionIndicator(
      {super.key, required this.lobbyRepository, required this.chatRepository});

  @override
  Widget build(BuildContext context) {
    final okMesssage =
        'Connection status is OK for both lobby and chat services';
    final notOkChatMessage =
        'Connection status is OK for lobby service, but not OK for chat service.\nTry to refresh the page.';
    final notOkLobbyMessage =
        'Connection status is OK for chat service, but not OK for lobby service.\nTry to refresh the page.';
    final notOkMessage =
        'Connection status is not OK for both lobby and chat services.\nTry to refresh the page.';
    return ValueListenableBuilder(
      valueListenable: lobbyRepository.isLobbyConnectionOk,
      builder: (context, isLobbyConnectionOk, child) {
        return ValueListenableBuilder(
          valueListenable: chatRepository.isChatConnectionOk,
          builder: (context, isChatConnectionOk, child) {
            return Tooltip(
              message: isLobbyConnectionOk && isChatConnectionOk
                  ? okMesssage
                  : isLobbyConnectionOk
                      ? notOkChatMessage
                      : isChatConnectionOk
                          ? notOkLobbyMessage
                          : notOkMessage,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: isLobbyConnectionOk && isChatConnectionOk
                      ? Colors.green
                      : Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
