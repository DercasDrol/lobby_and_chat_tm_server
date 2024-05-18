import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_category.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/lobby_view/kit/games_list/kit/game_row.dart';

class GamesList extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyCategory lobbyCategory;
  final double height;
  const GamesList({
    super.key,
    required this.lobbyCubit,
    required this.lobbyCategory,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();
    return BlocBuilder<LobbyCubit, LobbyState>(
        bloc: lobbyCubit,
        builder: (context, lobbyState) {
          final List<LobbyGame> games =
              (lobbyState.gamesList ?? {}).values.where((game) {
            if (lobbyCategory == LobbyCategory.GAMES_TO_JOIN) {
              return !game.isStarted;
            } else if (lobbyCategory == LobbyCategory.OWN_GAMES) {
              return game.isStarted && game.isPlayerJoined(lobbyCubit.userId);
            } else if (lobbyCategory == LobbyCategory.GAMES_TO_WATCH) {
              return game.isStarted && !game.isPlayerJoined(lobbyCubit.userId);
            } else {
              return false;
            }
          }).toList();
          return Container(
            padding: EdgeInsets.all(5),
            constraints: BoxConstraints(
              minHeight: height - 88,
              maxHeight: height - 88,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[700],
            ),
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              //reverse: true,
              cacheExtent: 100,
              itemCount: games.length,
              itemBuilder: (BuildContext context, int index) {
                var game = games[games.length - index - 1];
                return GameRow(
                  game: game,
                  lobbyCubit: lobbyCubit,
                );
              },
            ),
          );
        });
  }
}
