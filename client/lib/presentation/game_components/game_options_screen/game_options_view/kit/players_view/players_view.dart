import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/players_view/kit/empty_player_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/players_view/kit/player_view/player_view.dart';

class PlayersView extends StatelessWidget {
  final List<NewPlayerModel> players;
  final int maxPlayersCount;
  final bool showFirstPlayer;
  final bool isSharedGame;
  final bool isChangesAllowed;
  final String? allowColorChangeUserId;
  final void Function(List<NewPlayerModel>) onChangePlayersSettings;
  final void Function(int) onChangeMaxPlayersCount;

  const PlayersView({
    super.key,
    required this.players,
    required this.onChangePlayersSettings,
    required this.maxPlayersCount,
    required this.showFirstPlayer,
    required this.onChangeMaxPlayersCount,
    required this.isSharedGame,
    required this.isChangesAllowed,
    this.allowColorChangeUserId,
  });

  @override
  Widget build(BuildContext context) {
    final takenColors = players.map((e) => e.color).toList();
    final playersList = players
        .map(
          (p) => Container(
            padding: EdgeInsets.only(
                bottom: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
            child: PlayerView(
              player: p,
              showFirstPlayerOption: showFirstPlayer,
              isChangesAllowed: isChangesAllowed,
              allowColorChangeUserId: allowColorChangeUserId,
              onAnyOptionChanged: (player, isFirstPlayerChanged) {
                final newPlayers = players.map((e) {
                  if (e.userId == player.userId) {
                    return player;
                  } else if (isFirstPlayerChanged) {
                    return e.copyWith(first: false);
                  }
                  return e;
                }).toList();
                onChangePlayersSettings(newPlayers);
              },
              playerColors: PlayerColor.playerColors
                  .where((element) => !takenColors.contains(element))
                  .toList(),
            ),
          ),
        )
        .toList();
    final emptyPlayerViews = List.generate(
      maxPlayersCount - players.length,
      (index) => Container(
        padding:
            EdgeInsets.only(bottom: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
        child: EmptyPlayerView(isSharedGame: isSharedGame),
      ),
    );

    return Container(
      child: Column(
        children: [
          Text(
            'Players',
            style: GAME_OPTIONS_CONSTANTS.blockTitleStyle,
          ),
          SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
          ...playersList,
          ...emptyPlayerViews,
        ],
      ),
    );
  }
}
