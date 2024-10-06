import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

class PresentationAmountInfo {
  final String buttonLabel;
  final int max;
  final bool maxByDefault;
  final int min;
  final String title;
  final int value;

  PresentationAmountInfo({
    required this.buttonLabel,
    required this.max,
    required this.maxByDefault,
    required this.min,
    required this.title,
    required this.value,
  });

  copyWith({
    String? buttonLabel,
    int? max,
    bool? maxByDefault,
    int? min,
    String? title,
    int? value,
  }) {
    return PresentationAmountInfo(
      buttonLabel: buttonLabel ?? this.buttonLabel,
      max: max ?? this.max,
      maxByDefault: maxByDefault ?? this.maxByDefault,
      min: min ?? this.min,
      title: title ?? this.title,
      value: value ?? this.value,
    );
  }

  String? toImagePath() {
    if (title == 'Megacredits') {
      return Assets.resources.megacredit.path;
    } else if (title == 'Steel') {
      return Assets.resources.steel.path;
    } else if (title == 'Titanium') {
      return Assets.resources.titanium.path;
    } else if (title == 'Plants') {
      return Assets.resources.plant.path;
    } else if (title == 'Energy') {
      return Assets.resources.power.path;
    } else if (title == 'Heat') {
      return Assets.resources.heat.path;
    } else {
      return null;
    }
  }
}
