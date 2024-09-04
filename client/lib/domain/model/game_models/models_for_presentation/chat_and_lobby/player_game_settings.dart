import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Color.dart';

class PlayerGameSettings extends Equatable {
  final PlayerColor playerColor;

  PlayerGameSettings({
    required this.playerColor,
  });

  factory PlayerGameSettings.fromJson(Map<String, dynamic> e) {
    return PlayerGameSettings(
      playerColor: PlayerColor.fromString(e['playerColor'] as String) ??
          PlayerColor.NEUTRAL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerColor': playerColor.toString(),
    };
  }

  @override
  List<Object?> get props => [playerColor];
}
