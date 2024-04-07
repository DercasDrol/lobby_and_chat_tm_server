import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/common/game_option_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/players_view/kit/player_view/kit/color_selection.dart';

class PlayerView extends StatelessWidget {
  static const dropdownItems = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];
  final NewPlayerModel player;
  final bool showFirstPlayerOption;
  final bool isChangesAllowed;
  final List<PlayerColor> playerColors;
  final String? allowColorChangeUserId;
  final void Function(NewPlayerModel, bool) onAnyOptionChanged;
  const PlayerView({
    super.key,
    required this.player,
    //TODO: show first player icon if true
    required this.showFirstPlayerOption,
    required this.onAnyOptionChanged,
    required this.isChangesAllowed,
    required this.playerColors,
    required this.allowColorChangeUserId,
  });

  @override
  Widget build(BuildContext context) {
    prepareOnChangeFn(fn) => isChangesAllowed ? fn : null;
    final dropdownDefaultValueIdx =
        dropdownItems.indexOf(player.handicap.toString());
    return Container(
      decoration: BoxDecoration(
        color: player.color.toColor(false),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.0),
            child: GameOptionContainer(
              padding: EdgeInsets.zero,
              child: Row(children: [
                SizedBox(width: 10),
                ColorSelection(
                  onAnyOptionChanged: allowColorChangeUserId == player.userId ||
                          isChangesAllowed
                      ? onAnyOptionChanged
                      : null,
                  player: player,
                  availablePlayerColors: playerColors,
                ),
                GameOptionView(
                  lablePart1: player.name,
                  type: GameOptionType.SIMPLE,
                  fontColor: Colors.white,
                )
              ]),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.all(3.0),
              child: GameOptionContainer(
                padding: EdgeInsets.all(5),
                child: GameOptionView(
                  lablePart1: "Begginer?",
                  type: GameOptionType.TOGGLE_BUTTON,
                  descriptionUrl: BEGGINER_DESCRIPTION_URL,
                  isSelected: player.beginner,
                  onDropdownOptionChangedOrOptionToggled:
                      prepareOnChangeFn((__) {
                    onAnyOptionChanged(
                        player.copyWith(beginner: !player.beginner), false);
                  }),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3.0),
              child: GameOptionContainer(
                padding: EdgeInsets.all(3),
                child: GameOptionView(
                  lablePart2: "+TR",
                  type: GameOptionType.DROPDOWN,
                  dropdownOptions: dropdownItems,
                  dropdownDefaultValueIdx: dropdownDefaultValueIdx == -1
                      ? 0
                      : dropdownDefaultValueIdx,
                  descriptionUrl: TR_BOOST_DESCRIPTION_URL,
                  onDropdownOptionChangedOrOptionToggled:
                      prepareOnChangeFn((val) {
                    if (val != null)
                      onAnyOptionChanged(
                          player.copyWith(handicap: int.parse(val)), false);
                  }),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
