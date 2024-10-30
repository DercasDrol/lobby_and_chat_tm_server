import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';

class LobbyGameTemplate extends Equatable {
  final int id;
  final String name;
  final CreateGameModel createGameModel;

  LobbyGameTemplate({
    required this.id,
    required this.name,
    required this.createGameModel,
  });

  factory LobbyGameTemplate.fromJson(Map<String, dynamic> e) {
    final gameConfig =
        NewGameConfig.fromJson(e['newGameConfig'] as Map<String, dynamic>);
    return LobbyGameTemplate(
      id: e['id'] as int,
      name: e['name'] as String,
      createGameModel: CreateGameModel.fromGameConfig(gameConfig),
    );
  }

  String toShortJson() {
    return '''{"id":$id,"newGameConfig":${jsonEncode(NewGameConfig.fromCreateGameModel(createGameModel).toJson())},"name":"$name"}''';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        createGameModel,
      ];

  LobbyGameTemplate copyWith({
    int? id,
    String? name,
    CreateGameModel? createGameModel,
  }) {
    return LobbyGameTemplate(
      createGameModel: createGameModel ?? this.createGameModel,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
