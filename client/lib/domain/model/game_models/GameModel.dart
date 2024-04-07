import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Phase.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/ares/AresData.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';
import 'package:mars_flutter/domain/model/game_models/ColonyModel.dart';
import 'package:mars_flutter/domain/model/game_models/ma_model.dart';
import 'package:mars_flutter/domain/model/game_models/GameOptionsModel.dart';
import 'package:mars_flutter/domain/model/game_models/MoonModel.dart';
import 'package:mars_flutter/domain/model/game_models/PathfindersModel.dart';
import 'package:mars_flutter/domain/model/game_models/SpaceModel.dart';
import 'package:mars_flutter/domain/model/game_models/TurmoilModel.dart';

class GameModel extends Equatable {
  final AresData? aresData;
  final List<FundedAwardModel> awards;
  final List<ColonyModel> colonies;
  final List<ColonyName> discardedColonies;
  final int deckSize;
  final int expectedPurgeTimeMs;
  final int gameAge;
  final GameOptionsModel gameOptions;
  final int generation;
  final bool isSoloModeWin;
  final int lastSoloGeneration;
  final List<ClaimedMilestoneModel> milestones;
  final MoonModel? moon;
  final int oceans;
  final int oxygenLevel;
  final List<PlayerColor> passedPlayers;
  final PathfindersModel? pathfinders;
  final Phase phase;
  final List<SpaceModel> spaces;
  final SpectatorId? spectatorId;
  final int step;
  final int temperature;
  final bool isTerraformed;
  final TurmoilModel? turmoil;
  final int undoCount;
  final int venusScaleLevel;
  final bool? experimentalReset;

  GameModel({
    this.aresData,
    required this.awards,
    required this.colonies,
    required this.discardedColonies,
    required this.deckSize,
    required this.expectedPurgeTimeMs,
    required this.gameAge,
    required this.gameOptions,
    required this.generation,
    required this.isSoloModeWin,
    required this.lastSoloGeneration,
    required this.milestones,
    this.moon,
    required this.oceans,
    required this.oxygenLevel,
    required this.passedPlayers,
    this.pathfinders,
    required this.phase,
    required this.spaces,
    this.spectatorId,
    required this.step,
    required this.temperature,
    required this.isTerraformed,
    this.turmoil,
    required this.undoCount,
    required this.venusScaleLevel,
    this.experimentalReset,
  });

  static GameModel fromJson(Map<String, dynamic> json) {
    return GameModel(
      aresData:
          json['aresData'] != null ? AresData.fromJson(json['aresData']) : null,
      awards: json['awards'] != null
          ? json['awards']
              .map((i) => FundedAwardModel.fromJson(i))
              .cast<FundedAwardModel>()
              .toList()
          : null,
      colonies: json['colonies'] != null
          ? json['colonies']
              .map((i) => ColonyModel.fromJson(i))
              .cast<ColonyModel>()
              .toList()
          : null,
      discardedColonies: json['discardedColonies'] != null
          ? json['discardedColonies']
              .map((i) => ColonyName.fromString(i as String))
              .cast<ColonyName>()
              .toList()
          : null,
      deckSize: json['deckSize'] as int,
      expectedPurgeTimeMs: json['expectedPurgeTimeMs'] as int,
      gameAge: json['gameAge'] as int,
      gameOptions: GameOptionsModel.fromJson(json['gameOptions']),
      generation: json['generation'],
      isSoloModeWin: json['isSoloModeWin'],
      lastSoloGeneration: json['lastSoloGeneration'],
      milestones: json['milestones']
          .map((i) => ClaimedMilestoneModel.fromJson(i))
          .cast<ClaimedMilestoneModel>()
          .toList(),
      moon: json['moon'] != null ? MoonModel.fromJson(json['moon']) : null,
      oceans: json['oceans'] as int,
      oxygenLevel: json['oxygenLevel'] as int,
      passedPlayers: json['passedPlayers'] != null
          ? json['passedPlayers']
              .map((i) => PlayerColor.fromString(i))
              .cast<PlayerColor>()
              .toList()
          : null,
      pathfinders: json['pathfinders'] != null
          ? PathfindersModel.fromJson(json['pathfinders'])
          : null,
      phase: json['phase'] != null ? Phase.fromString(json['phase']) : null,
      spaces: json['spaces'] != null
          ? json['spaces']
              .map((i) => SpaceModel.fromJson(i))
              .cast<SpaceModel>()
              .toList()
          : null,
      spectatorId: SpectatorId.fromString(json['spectatorId'] as String),
      step: json['step'] as int,
      temperature: json['temperature'] as int,
      isTerraformed: json['isTerraformed'] as bool,
      turmoil: json['turmoil'] != null
          ? TurmoilModel.fromJson(json['turmoil'])
          : null,
      undoCount: json['undoCount'],
      venusScaleLevel: json['venusScaleLevel'],
      experimentalReset: json['experimentalReset'],
    );
  }

  @override
  List<Object?> get props => [
        aresData,
        awards,
        colonies,
        discardedColonies,
        deckSize,
        expectedPurgeTimeMs,
        gameAge,
        gameOptions,
        generation,
        isSoloModeWin,
        lastSoloGeneration,
        milestones,
        moon,
        oceans,
        oxygenLevel,
        passedPlayers,
        pathfinders,
        phase,
        spaces,
        spectatorId,
        step,
        temperature,
        isTerraformed,
        turmoil,
        undoCount,
        venusScaleLevel,
        experimentalReset,
      ];
}
