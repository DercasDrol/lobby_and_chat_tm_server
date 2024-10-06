import 'package:mars_flutter/domain/model/game_models/MoonModel.dart';

enum GlobalScale {
  TEMPERATURE,
  OXYGEN_LEVEL,
  OCEANS,
  VENUS_SCALE,
  MOON_COLONY,
  MOON_MINING,
  MOON_LOGISTICS
}

enum ScaleAction { INCREASE, DECREASE }

class PresentationGlobalScalesInfo {
  final int oceans;
  final int oxygenLevel;
  final int temperature;
  final int? venusScaleLevel;
  final MoonModel? moon;
  final ScaleAction? scaleAction;
  final List<GlobalScale> availableScalesToAction;
  final void Function(GlobalScale)? onChangeAction;

  PresentationGlobalScalesInfo({
    required this.oceans,
    required this.oxygenLevel,
    required this.temperature,
    this.venusScaleLevel,
    this.moon,
    this.scaleAction,
    this.onChangeAction,
    this.availableScalesToAction = const [],
  });
}
