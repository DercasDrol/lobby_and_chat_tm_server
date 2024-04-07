import 'package:mars_flutter/domain/model/Types.dart';

class Player {
  final String userId;
  final PlayerId playerId;
  final int lobbyGameId;

  Player({
    required this.userId,
    required this.playerId,
    required this.lobbyGameId,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json['userId'],
      playerId: PlayerId.fromString(json['serverPlayerId'] as String),
      lobbyGameId: json['lobbyGameId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'serverPlayerId': playerId.toString(),
        'lobbyGameId': lobbyGameId,
      };
}
