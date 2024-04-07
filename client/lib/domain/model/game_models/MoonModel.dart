import 'package:mars_flutter/domain/model/game_models/SpaceModel.dart';

class MoonModel {
  final List<SpaceModel> spaces;
  final int colonyRate;
  final int miningRate;
  final int logisticsRate;
  MoonModel({
    required this.spaces,
    required this.colonyRate,
    required this.miningRate,
    required this.logisticsRate,
  });

  static MoonModel fromJson(Map<String, dynamic> json) {
    return MoonModel(
      spaces: json['spaces']
          .map((e) => SpaceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      colonyRate: json['colonyRate'] as int,
      miningRate: json['miningRate'] as int,
      logisticsRate: json['logisticsRate'] as int,
    );
  }
}
