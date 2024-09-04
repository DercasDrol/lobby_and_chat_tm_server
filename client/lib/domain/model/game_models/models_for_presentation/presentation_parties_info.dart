import 'package:mars_flutter/domain/model/game_models/TurmoilModel.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';

class PresentationTurmoilInfo {
  final TurmoilModel turmoilModel;
  final Function(PartyName)? onConfirm;
  static const int delegateCost = 5;
  PresentationTurmoilInfo({
    required this.turmoilModel,
    this.onConfirm,
  });
}
