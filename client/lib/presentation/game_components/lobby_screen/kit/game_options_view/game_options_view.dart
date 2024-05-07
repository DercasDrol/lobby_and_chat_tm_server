import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/boards_options_view/boards_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/bottom_buttons_view/bottom_buttons_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/common_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/expansions_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/expansions_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/filters_options_view/filters_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/multiplayer_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/players_options_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/players_view/players_view.dart';

class GameOptionsView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  final bool isOwnGame;
  final double width;
  final double height;
  final bool isForTooltip;
  final String? allowColorChangeUserId;

  const GameOptionsView({
    super.key,
    required this.lobbyCubit,
    required this.width,
    required this.height,
    required this.lobbyGame,
    required this.isOwnGame,
    this.isForTooltip = false,
    this.allowColorChangeUserId,
  });

  @override
  Widget build(BuildContext context) {
    final CreateGameModel createGameModel = lobbyGame.createGameModel;
    final isChangesAllowed =
        lobbyGame.startedAt == null && isOwnGame && !isForTooltip;
    prepareOnChangeFn(fn) => isChangesAllowed ? fn : null;

    final expansionsView = ExpansionsView(
      expansions: CreateGameModel.expansions,
      selectedExpansions: createGameModel.selectedExpansions,
      onSelectedExpansionsChanged: prepareOnChangeFn(
        (selectedExpansionsList) {
          final newCreateGameModel = lobbyGame.createGameModel.copyWith(
            selectedExpansions: selectedExpansionsList,
          );

          lobbyCubit.saveChangedOptions(
            lobbyGame.copyWith(createGameModel: newCreateGameModel),
          );
        },
      ),
    );

    final boardsOptionsView = BoardsOptionsView(
      createGameModel: createGameModel,
      isChangesAllowed: isChangesAllowed,
      lobbyCubit: lobbyCubit,
      lobbyGame: lobbyGame,
    );

    final playersOptionsView = PlayersOptionsView(
      isChangesAllowed: isChangesAllowed,
      lobbyCubit: lobbyCubit,
      lobbyGame: lobbyGame,
    );

    final playersView = PlayersView(
      players: createGameModel.players,
      onChangePlayersSettings: isChangesAllowed
          ? (players) {
              final newCreateGameModel =
                  lobbyGame.createGameModel.copyWith(players: players);

              lobbyCubit.saveChangedOptions(
                lobbyGame.copyWith(createGameModel: newCreateGameModel),
              );
            }
          : lobbyGame.startedAt == null
              ? (players) {
                  final newCreateGameModel =
                      lobbyGame.createGameModel.copyWith(players: players);

                  lobbyCubit.changePlayerColor(
                    lobbyGame.copyWith(
                      createGameModel: newCreateGameModel,
                    ),
                  );
                }
              : (_) {},
      maxPlayersCount: createGameModel.maxPlayers,
      showFirstPlayer: createGameModel.randomFirstPlayer,
      isSharedGame: lobbyGame.isSharedGame,
      isChangesAllowed: isChangesAllowed,
      onChangeMaxPlayersCount: (int) {
        final newCreateGameModel =
            lobbyGame.createGameModel.copyWith(maxPlayers: int);

        lobbyCubit.saveChangedOptions(
          lobbyGame.copyWith(createGameModel: newCreateGameModel),
        );
      },
      allowColorChangeUserId: allowColorChangeUserId,
    );

    final expansionsOptionsView = ExpansionsOptionsView(
      isChangesAllowed: isChangesAllowed,
      lobbyGame: lobbyGame,
      lobbyCubit: lobbyCubit,
    );

    final getMultiplayerOptionsView = () => MultiplayerOptionsView(
          isChangesAllowed: isChangesAllowed,
          lobbyGame: lobbyGame,
          lobbyCubit: lobbyCubit,
        );

    final commonOptionsView = CommonOptionsView(
      lobbyGame: lobbyGame,
      lobbyCubit: lobbyCubit,
      isChangesAllowed: isChangesAllowed,
    );

    final filterOptionsView = FiltersOptionsView(
      lobbyGame: lobbyGame,
      lobbyCubit: lobbyCubit,
      isChangesAllowed: isChangesAllowed,
    );

    final tooltipVersion = Container(
      padding: EdgeInsets.all(5),
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.471),
              child: Column(children: [
                boardsOptionsView,
                commonOptionsView,
              ]),
            ),
            SizedBox(width: 5),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.51),
              child: Column(children: [
                expansionsOptionsView,
                if (createGameModel.maxPlayers > 1) getMultiplayerOptionsView(),
              ]),
            )
          ],
        ),
      ),
    );

    return isForTooltip
        ? tooltipVersion
        : Container(
            constraints: BoxConstraints(
              minWidth: width,
              minHeight: height,
              maxWidth: width,
              maxHeight: height,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  constraints: BoxConstraints(
                    minHeight: height - 38,
                    maxHeight: height - 38,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      expansionsView,
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: width * 0.44, maxWidth: width * 0.44),
                            child: Column(children: [
                              boardsOptionsView,
                              playersOptionsView,
                              playersView,
                            ]),
                          ),
                          SizedBox(width: 10),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: width * 0.52, maxWidth: width * 0.52),
                            child: Column(children: [
                              expansionsOptionsView,
                              if (createGameModel.maxPlayers > 1)
                                getMultiplayerOptionsView(),
                              commonOptionsView,
                              filterOptionsView,
                            ]),
                          )
                        ],
                      ),
                    ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: ButtomButtonsView(
                    isOwnGame: isOwnGame,
                    lobbyCubit: lobbyCubit,
                    lobbyGame: lobbyGame,
                  ),
                ),
              ],
            ),
          );
  }
}
