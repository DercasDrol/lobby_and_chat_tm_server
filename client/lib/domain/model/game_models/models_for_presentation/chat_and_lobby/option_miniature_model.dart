import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/expansion_type.dart';

class OptionMiniatureModel {
  final String icon;
  final String? additionalOptions;
  final bool? isSelected;

  OptionMiniatureModel({
    required this.icon,
    this.additionalOptions,
    this.isSelected,
  });

  factory OptionMiniatureModel.fromExpansionType(
    ExpansionType expansion,
    bool? isSelected,
  ) {
    return OptionMiniatureModel(
      icon: expansion.typeImage,
      additionalOptions: null,
      isSelected: isSelected,
    );
  }
}
