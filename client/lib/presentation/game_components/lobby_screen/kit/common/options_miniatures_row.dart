import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/option_miniature_model.dart';

class OptionMiniaturesRow extends StatelessWidget {
  final List<OptionMiniatureModel> options;

  const OptionMiniaturesRow({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final grayOut = (child) => Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            backgroundBlendMode: BlendMode.multiply,
          ),
          child: child,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: options.map((e) {
        final optionView = Row(
          children: [
            Image.asset(e.icon, width: 24, height: 24),
            if (e.additionalOptions != null) Text(e.additionalOptions!),
          ],
        );
        return e.isSelected ?? true ? optionView : grayOut(optionView);
      }).toList(),
    );
  }
}
