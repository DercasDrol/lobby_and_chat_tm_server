import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/expansion_type.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_game.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/card_body.dart';
import 'package:collection/collection.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/boards_options_view/boards_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/common_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/expansions_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/expansions_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/filters_options_view/filters_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/multiplayer_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/players_options_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/players_view/players_view.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/templates_view.dart';

class GameOptionsView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final LobbyGame lobbyGame;
  final bool isOwnGame;
  final bool isForTooltip;
  final String? allowColorChangeUserId;

  const GameOptionsView({
    super.key,
    required this.lobbyCubit,
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
        (List<ExpansionType> selectedExpansionsList) {
          if (!ListEquality().equals(
              lobbyGame.createGameModel.selectedExpansions,
              selectedExpansionsList)) {
            final newCreateGameModel = lobbyGame.createGameModel.copyWith(
              selectedExpansions: selectedExpansionsList,
            );
            lobbyCubit.saveChangedOptions(
              lobbyGame.copyWith(createGameModel: newCreateGameModel),
            );
          }
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
    final tooltipWidth = 530.0;
    final tooltipHeight = 500.0;

    final tooltipVersion = Container(
      padding: EdgeInsets.all(5),
      constraints: BoxConstraints(
        maxWidth: tooltipWidth,
        maxHeight: tooltipHeight,
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
            SizedBox(
              child: Column(children: [
                boardsOptionsView,
                commonOptionsView,
              ]),
            ),
            SizedBox(width: 5),
            SizedBox(
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
        : LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final internalHeight = height - (isChangesAllowed ? 45 : 0);
            final columnsMaxWidth = 400.0;
            final columnMinWidth = 310.0;
            final columnCount = min(3, width ~/ columnMinWidth);
            final columnWidth = min(
              columnsMaxWidth,
              (width - (columnCount - 1) * 20) / columnCount,
            );
            return OverflowBox(
              minWidth: columnMinWidth + 20,
              minHeight: height,
              maxWidth: max(width, columnMinWidth + 20),
              maxHeight: height,
              alignment: Alignment.centerLeft,
              fit: OverflowBoxFit.deferToChild,
              child: Container(
                width: width,
                height: height,
                constraints: BoxConstraints(
                  minWidth: 0,
                  maxWidth: width,
                  minHeight: height,
                  maxHeight: height,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isChangesAllowed) TemplatesView(lobbyCubit: lobbyCubit),
                    Container(
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(
                        minHeight: internalHeight,
                        maxHeight: internalHeight,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SizedBox(
                              width: columnWidth,
                              child: Column(children: [
                                expansionsView,
                                boardsOptionsView,
                                playersOptionsView,
                                playersView,
                              ]),
                            ),
                            SizedBox(
                              width: columnWidth,
                              child: Column(children: [
                                expansionsOptionsView,
                                commonOptionsView,
                              ]),
                            ),
                            SizedBox(
                              width: columnWidth,
                              child: Column(children: [
                                if (createGameModel.maxPlayers > 1)
                                  getMultiplayerOptionsView(),
                                filterOptionsView,
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
  }
}
