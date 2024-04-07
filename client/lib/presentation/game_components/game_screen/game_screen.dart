import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/chat/chat_api_client.dart';
import 'package:mars_flutter/data/api/game/game_api_client.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/logs_cubit.dart';
import 'package:mars_flutter/domain/logs_state.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/game_cubit.dart';
import 'package:mars_flutter/domain/game_state.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_planet_info.dart';
import 'package:mars_flutter/domain/model/inputs/InputResponse.dart';
import 'package:mars_flutter/presentation/game_components/common/stars_background.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/global_parameters/generation.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/global_parameters/global_parameter_scale.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/logs_panel/logs_panel.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_tabs/ma_tabs.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/planet/planet_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/player_panel.dart';
import 'package:mars_flutter/presentation/game_components/common/show_popup_with_error.dart';

class GameScreen extends StatelessWidget {
  final GameAPIClient marsRepository;
  final ParticipantId participantId;
  const GameScreen({
    super.key,
    required this.marsRepository,
    required ChatAPIClient chatRepository,
    required this.participantId,
  });

  @override
  Widget build(BuildContext context) {
    final LogsCubit logsCubit = LogsCubit(
      repository: marsRepository,
    );
    final GameCubit gameCubit = GameCubit(
      repository: marsRepository,
      additionalOnChangeFn: (
        List<PublicPlayerModel>? players,
        int generation,
        ParticipantId participantId,
      ) =>
          logsCubit.getGameLogs(players, generation, participantId),
    )..setParticipant(participantId);

    final PresentationPlanetInfoCN planetInfo =
        PresentationPlanetInfoCN(spaceModels: []);
    return Scaffold(
      body: Container(
        child: BlocBuilder<GameCubit, GameState>(
            bloc: gameCubit,
            builder: (context, gameState) => ScreenBuilder(
                  context: context,
                  planetInfoCN: planetInfo,
                  state: gameState,
                  logsCubit: logsCubit,
                  sendPlayerAction: gameCubit.sendPlayerAction,
                  tryChangeActiveParticipant:
                      gameCubit.tryChangeActiveParticipant,
                  fetch: gameCubit.fetch,
                )),
      ),
    );
  }
}

class ScreenBuilder extends StatelessWidget {
  final BuildContext context;
  final PresentationPlanetInfoCN planetInfoCN;
  final LogsCubit logsCubit;
  final GameState state;
  final Future<void> Function(InputResponse) sendPlayerAction;

  final void Function(PlayerColor) tryChangeActiveParticipant;
  final Function fetch;
  const ScreenBuilder({
    super.key,
    required this.context,
    required this.planetInfoCN,
    required this.logsCubit,
    required this.state,
    required this.sendPlayerAction,
    required this.tryChangeActiveParticipant,
    required this.fetch,
  });
  static const double _globalParameterScaleWidth = 35.0;
  static const double _globalParameterScaleHeight = 500.0;
  static const double _topPanelMaxHeight = 135.0;

  static const double _playerBoardHeight = 50;

  Widget _preparePlayerBoards(
    BuildContext context,
    ViewModel viewModel,
    Future<void> Function(InputResponse) sendPlayerAction,
    void Function(PlayerColor) tryChangeActiveParticipant,
    PresentationPlanetInfoCN planetInfo,
  ) {
    final PublicPlayerModel? thisPlayer = viewModel.thisPlayer;
    final thisPlayerIndex = viewModel.players
        .indexWhere((player) => player.color == thisPlayer?.color);
    final List<PublicPlayerModel> sortedPlayers = thisPlayerIndex < 0
        ? viewModel.players
        : [
            ...viewModel.players.sublist(thisPlayerIndex),
            ...viewModel.players.sublist(0, thisPlayerIndex),
          ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: sortedPlayers.map(
        (player) {
          final playerPanelInfo = viewModel.getPresentationPlayerPanelInfo(
            player: player,
            sendPlayerAction: sendPlayerAction,
            onUserError: (String message) =>
                showPopupWithError(context: context, text: message),
            planetInfo: planetInfo,
          );
          return PlayerPanelView(
            width: 760 + playerPanelInfo.tagsInfo.length * 25,
            height: _playerBoardHeight,
            onNameClick: () => tryChangeActiveParticipant(player.color),
            playerPanelInfo: playerPanelInfo,
            topPopupPadding: _topPanelMaxHeight,
            bottomPopupPadding: _playerBoardHeight * viewModel.players.length,
          );
        },
      ).toList(),
    );
  }

  Widget _prepareGlobalStatePanel(ViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: GlobalParameterScaleView(
                  startValue: 0,
                  endValue: 14,
                  stepValue: 1,
                  currentValue: viewModel.game.oxygenLevel,
                  width: _globalParameterScaleWidth,
                  height: _globalParameterScaleHeight,
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.black,
                  ],
                  icon: Image.asset(Assets.globalParameters.oxygen.path),
                  backgroundImage: Assets.misc.oxigenBackground2.path,
                  backgroundImageOpacity: 0.5,
                  bonusItems: {
                    8: Image.asset(Assets.globalParameters.temperature.path),
                  },
                  header: "O2",
                  suffix: "%",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 00.0),
                child: GlobalParameterScaleView(
                  startValue: 0,
                  endValue: 9,
                  stepValue: 1,
                  currentValue: viewModel.game.oceans,
                  width: _globalParameterScaleWidth,
                  height: _globalParameterScaleHeight,
                  colors: [
                    Colors.blue.withOpacity(0.9),
                    Colors.blue.withOpacity(0.9),
                  ],
                  backgroundImage: Assets.misc.oceanBackground1.path,
                  icon: Image.asset(Assets.tiles.ocean.path),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: GlobalParameterScaleView(
                  startValue: -30,
                  endValue: 8,
                  stepValue: 2,
                  currentValue: viewModel.game.temperature,
                  width: _globalParameterScaleWidth,
                  height: _globalParameterScaleHeight,
                  colors: [
                    Colors.red.withOpacity(0.4),
                    Colors.blue.withOpacity(0.5),
                    Colors.blue.withOpacity(0.7),
                  ],
                  icon: Image.asset(Assets.globalParameters.temperature.path),
                  bonusItems: {
                    0: Image.asset(Assets.tiles.ocean.path),
                    -20: Image.asset(Assets.resources.heat.path),
                    -24: Image.asset(Assets.resources.heat.path),
                  },
                  header: "t°C",
                  suffix: "°",
                  showPlusForPositiveValues: true,
                ),
              ),
              viewModel.game.gameOptions.venusNextExtension
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: GlobalParameterScaleView(
                        startValue: 0,
                        endValue: 30,
                        stepValue: 2,
                        currentValue: viewModel.game.venusScaleLevel,
                        width: _globalParameterScaleWidth,
                        height: _globalParameterScaleHeight,
                        colors: [
                          Colors.blue.withOpacity(0.7),
                          Colors.orange.withOpacity(0.7),
                        ],
                        icon: Image.asset(Assets.globalParameters.venus.path),
                        bonusItems: {
                          8: Image.asset(Assets.resources.card.path),
                          16: Image.asset(Assets.resources.tr.path),
                        },
                        header: "%",
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prepareTopBoardPanel(ViewModel viewModel, sendPlayerAction, logs) {
    return FittedBox(
        child: Row(
      children: [
        MaTabs(
          maxHeight: _topPanelMaxHeight,
          awardsInfo: viewModel.getAwardsInfo(
              sendPlayerAction: sendPlayerAction, logs: logs),
          milestonesInfo:
              viewModel.getMilestonesInfo(sendPlayerAction: sendPlayerAction),
          playerColor:
              viewModel.thisPlayer?.color.toColor(false) ?? Colors.white,
        ),
        GenerationView(
          generationValue: viewModel.game.generation,
          size: _globalParameterScaleWidth * 2.5,
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Debug: game screen build");
    Navigator.of(this.context).popUntil((route) => route.isActive);
    final getGameView = (
      bool isApiOk,
      PresentationPlanetInfoCN? planetInfoCN,
    ) =>
        state.viewModel != null
            ? Stack(
                children: [
                  StarsBackground(),
                  planetInfoCN == null
                      ? SizedBox.shrink()
                      : MarsView(planetInfoCN: planetInfoCN),
                  Align(
                    alignment: Alignment.topCenter,
                    child: BlocBuilder<LogsCubit, LogsState>(
                      bloc: logsCubit,
                      builder: (context, logsState) => _prepareTopBoardPanel(
                        state.viewModel!,
                        sendPlayerAction,
                        logsState.logs,
                      ),
                    ),
                  ),
                  planetInfoCN == null
                      ? SizedBox.shrink()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: _preparePlayerBoards(
                            context,
                            state.viewModel!,
                            sendPlayerAction,
                            tryChangeActiveParticipant,
                            planetInfoCN,
                          ),
                        ),
                  _prepareGlobalStatePanel(state.viewModel!),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Tooltip(
                      message:
                          "This button will refresh the game state, if you have any problems with it." +
                              "\n Green color means that the game state is ok, red - not ok." +
                              (state.error != null
                                  ? "\n Error: ${state.error}"
                                  : ""),
                      textStyle: TextStyle(fontSize: 16, color: Colors.white),
                      waitDuration: Duration(milliseconds: 300),
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: isApiOk ? Colors.green : Colors.red,
                        onPressed: () {
                          fetch();
                        },
                        child: Icon(Icons.refresh),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LogsPanel(
                      logsCubit: logsCubit,
                      topPadding: _topPanelMaxHeight,
                      bottomPadding: _playerBoardHeight *
                          (state.viewModel!.players.length + 1),
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator());
    switch (state.status) {
      case ViewModelStatus.failure:
        return getGameView(false, null);
      case ViewModelStatus.success:
        final PresentationPlanetInfoCN? newPlanetInfo =
            state.viewModel?.getPlanetInfo(
          sendPlayerAction: sendPlayerAction,
        );
        //planetInfo should be updated here because planetInfo is ChangeNotifier
        planetInfoCN.spaceModels = newPlanetInfo?.spaceModels ?? [];
        planetInfoCN.availableSpaces = newPlanetInfo?.availableSpaces;
        planetInfoCN.onConfirm = newPlanetInfo?.onConfirm;
        planetInfoCN.activePlayer = newPlanetInfo?.activePlayer;

        return getGameView(true, planetInfoCN);
      case ViewModelStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return const Center(child: Text('Oops something went wrong!'));
    }
  }
}
