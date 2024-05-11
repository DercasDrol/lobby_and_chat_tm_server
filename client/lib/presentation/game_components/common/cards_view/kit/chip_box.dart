import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';

class ChipBox extends StatelessWidget {
  final int labelSymbolCount;
  final bool useImage;
  final Widget child;

  const ChipBox({
    super.key,
    required this.labelSymbolCount,
    required this.useImage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: labelSymbolCount.toDouble() * 10.0 + (useImage ? 50.0 : 0.0),
      margin: const EdgeInsets.all(3.0),
      child: GameOptionContainer(
        child: child,
      ),
    );
  }
}
