import 'package:mars_flutter/domain/model/Color.dart';

class SpectatorModel {
  final PlayerColor color;

  SpectatorModel({
    required this.color,
  });

  factory SpectatorModel.fromJson(Map<String, dynamic> json) {
    return SpectatorModel(
      color: PlayerColor.fromString(json['color']),
    );
  }
}
