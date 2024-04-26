import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class TopButtonsBlock extends StatelessWidget {
  const TopButtonsBlock({
    required this.onBack,
    required this.showLeftBlock,
    required this.showRightBlock,
  });

  final VoidCallback onBack;
  final ValueNotifier<bool> showLeftBlock;
  final ValueNotifier<bool> showRightBlock;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrain) => GameOptionContainer(
        padding: EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBack,
              iconSize: 20.0,
              color: Colors.white,
              splashRadius: 5.0,
              padding: EdgeInsets.all(0.0),
            ),
            Container(
              width: constrain.maxWidth - 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                    valueListenable: showLeftBlock,
                    builder: (context, value, child) => GameOptionView(
                      lablePart1: " Show Flutter Cards ",
                      type: GameOptionType.TOGGLE_BUTTON,
                      isSelected: value,
                      onDropdownOptionChangedOrOptionToggled: (_) =>
                          showLeftBlock.value = !showLeftBlock.value,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: showRightBlock,
                    builder: (context, value, child) => GameOptionView(
                      lablePart1: " Show Game Server Cards ",
                      type: GameOptionType.TOGGLE_BUTTON,
                      isSelected: value,
                      onDropdownOptionChangedOrOptionToggled: (_) =>
                          showRightBlock.value = !showRightBlock.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
