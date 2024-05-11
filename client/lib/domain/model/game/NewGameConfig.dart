import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/boards/BoardNameType.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/create_game_model.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/expansion_type.dart';
import 'package:mars_flutter/domain/model/ma/RandomMAOptionType.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';

class NewPlayerModel extends Equatable {
  final int index;
  final String userId;
  final String name;
  final PlayerColor color;
  final bool beginner;
  final int handicap;
  final bool first;

  NewPlayerModel({
    required this.index,
    required this.userId,
    required this.name,
    required this.color,
    required this.beginner,
    required this.handicap,
    required this.first,
  });

  NewPlayerModel copyWith({
    int? index,
    String? userId,
    String? name,
    PlayerColor? color,
    bool? beginner,
    int? handicap,
    bool? first,
  }) {
    return NewPlayerModel(
      index: index ?? this.index,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      color: color ?? this.color,
      beginner: beginner ?? this.beginner,
      handicap: handicap ?? this.handicap,
      first: first ?? this.first,
    );
  }

  factory NewPlayerModel.fromJson(Map<String, dynamic> e) {
    return NewPlayerModel(
      index: e['index'] as int,
      userId: e['userId'] as String,
      name: e['name'] as String,
      color: PlayerColor.fromString(e['color'] as String),
      beginner: e['beginner'] as bool,
      handicap: e['handicap'] as int,
      first: e['first'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'userId': userId,
      'name': name,
      'color': color.toString(),
      'beginner': beginner,
      'handicap': handicap,
      'first': first,
    };
  }

  @override
  List<Object?> get props =>
      [index, userId, name, color, beginner, handicap, first];
}

class NewGameConfig extends Equatable {
  final List<NewPlayerModel> players;
  final int maxPlayers;
  final bool prelude;
  final bool venusNext;
  final bool colonies;
  final bool turmoil;
  final BoardNameType board;
  final double seed;
  final bool initialDraft;
  final bool randomFirstPlayer;

  final GameId? clonedGamedId;

  // Configuration
  final bool undoOption;
  final bool showTimers;
  final bool fastModeOption;
  final bool showOtherPlayersVP;

  // Extensions
  final bool corporateEra;
  final bool prelude2Expansion;
  final bool promoCardsOption;
  final bool communityCardsOption;
  final bool aresExtension;
  final AgendaStyle politicalAgendasExtension;
  final bool solarPhaseOption;
  final bool removeNegativeGlobalEventsOption;
  final bool includeVenusMA;
  final bool moonExpansion;
  final bool pathfindersExpansion;
  final bool ceoExtension;

  // Variants
  final bool draftVariant;
  final int startingCorporations;
  final bool shuffleMapOption;
  final RandomMAOptionType randomMA;
  final bool includeFanMA;
  final bool soloTR; // Solo victory by getting TR 63 by game end
  final List<CardName> customCorporationsList;
  final List<CardName> bannedCards;
  final List<CardName> includedCards;
  final List<ColonyName> customColoniesList;
  final List<CardName> customPreludes;
  final bool
      requiresMoonTrackCompletion; // Moon must be completed to end the game
  final bool
      requiresVenusTrackCompletion; // Venus must be completed to end the game
  final bool moonStandardProjectVariant;
  final bool altVenusBoard;
  final bool escapeVelocityMode;
  final int? escapeVelocityThreshold;
  final int? escapeVelocityBonusSeconds;
  final int? escapeVelocityPeriod;
  final int? escapeVelocityPenalty;
  final bool twoCorpsVariant;
  final List<CardName> customCeos;
  final bool? preludeDraftVariant;
  final int startingCeos;

  final bool starWarsExpansion;
  final bool underworldExpansion;

  NewGameConfig({
    required this.players,
    required this.maxPlayers,
    required this.prelude,
    required this.venusNext,
    required this.colonies,
    required this.turmoil,
    required this.board,
    required this.seed,
    required this.initialDraft,
    required this.randomFirstPlayer,
    this.clonedGamedId,
    required this.undoOption,
    required this.showTimers,
    required this.fastModeOption,
    required this.showOtherPlayersVP,
    required this.corporateEra,
    required this.prelude2Expansion,
    required this.promoCardsOption,
    required this.communityCardsOption,
    required this.aresExtension,
    required this.politicalAgendasExtension,
    required this.solarPhaseOption,
    required this.removeNegativeGlobalEventsOption,
    required this.includeVenusMA,
    required this.moonExpansion,
    required this.pathfindersExpansion,
    required this.ceoExtension,
    required this.draftVariant,
    required this.startingCorporations,
    required this.shuffleMapOption,
    required this.randomMA,
    required this.includeFanMA,
    required this.soloTR,
    required this.customCorporationsList,
    required this.bannedCards,
    required this.includedCards,
    required this.customColoniesList,
    required this.customPreludes,
    required this.requiresMoonTrackCompletion,
    required this.requiresVenusTrackCompletion,
    required this.moonStandardProjectVariant,
    required this.altVenusBoard,
    required this.escapeVelocityMode,
    this.escapeVelocityThreshold,
    this.escapeVelocityBonusSeconds,
    this.escapeVelocityPeriod,
    this.escapeVelocityPenalty,
    required this.twoCorpsVariant,
    required this.customCeos,
    this.preludeDraftVariant,
    required this.startingCeos,
    required this.starWarsExpansion,
    required this.underworldExpansion,
  });

  factory NewGameConfig.fromCreateGameModel(CreateGameModel createGameModel) {
    return NewGameConfig(
      players: createGameModel.players,
      maxPlayers: createGameModel.maxPlayers,
      prelude:
          createGameModel.selectedExpansions.contains(ExpansionType.PRELUDE),
      venusNext:
          createGameModel.selectedExpansions.contains(ExpansionType.VENUS_NEXT),
      colonies:
          createGameModel.selectedExpansions.contains(ExpansionType.COLONIES),
      turmoil:
          createGameModel.selectedExpansions.contains(ExpansionType.TURMOIL),
      board: createGameModel.board,
      seed: createGameModel.seed,
      initialDraft: createGameModel.initialDraft,
      randomFirstPlayer: createGameModel.randomFirstPlayer,
      clonedGamedId: createGameModel.clonedGameId,
      undoOption: createGameModel.undoOption,
      showTimers: createGameModel.showTimers,
      fastModeOption: createGameModel.fastModeOption,
      showOtherPlayersVP: createGameModel.showOtherPlayersVP,
      corporateEra: createGameModel.selectedExpansions
          .contains(ExpansionType.CORPORATE_ERA),
      prelude2Expansion:
          createGameModel.selectedExpansions.contains(ExpansionType.PRELUDE2),
      promoCardsOption:
          createGameModel.selectedExpansions.contains(ExpansionType.PROMO),
      communityCardsOption:
          createGameModel.selectedExpansions.contains(ExpansionType.COMMUNITY),
      aresExtension:
          createGameModel.selectedExpansions.contains(ExpansionType.ARES),
      politicalAgendasExtension: createGameModel.politicalAgendasExtension,
      solarPhaseOption: createGameModel.solarPhaseOption,
      removeNegativeGlobalEventsOption:
          createGameModel.removeNegativeGlobalEventsOption,
      includeVenusMA: createGameModel.includeVenusMA,
      moonExpansion:
          createGameModel.selectedExpansions.contains(ExpansionType.MOON),
      pathfindersExpansion: createGameModel.selectedExpansions
          .contains(ExpansionType.PATHFINDERS),
      ceoExtension:
          createGameModel.selectedExpansions.contains(ExpansionType.CEO),
      draftVariant: createGameModel.draftVariant,
      startingCorporations: createGameModel.startingCorporations,
      shuffleMapOption: createGameModel.shuffleMapOption,
      randomMA: createGameModel.randomMA,
      includeFanMA: createGameModel.includeFanMA,
      soloTR: createGameModel.soloTR,
      customCorporationsList: createGameModel.customCorporations,
      bannedCards: createGameModel.bannedCards,
      includedCards: createGameModel.includedCards,
      customColoniesList: createGameModel.customColonies,
      customPreludes: createGameModel.customPreludes,
      requiresMoonTrackCompletion: createGameModel.requiresMoonTrackCompletion,
      requiresVenusTrackCompletion:
          createGameModel.requiresVenusTrackCompletion,
      moonStandardProjectVariant: createGameModel.moonStandardProjectVariant,
      altVenusBoard: createGameModel.altVenusBoard,
      escapeVelocityMode: createGameModel.escapeVelocityMode,
      escapeVelocityThreshold: createGameModel.escapeVelocityThreshold,
      escapeVelocityBonusSeconds: createGameModel.escapeVelocityBonusSeconds,
      escapeVelocityPeriod: createGameModel.escapeVelocityPeriod,
      escapeVelocityPenalty: createGameModel.escapeVelocityPenalty,
      twoCorpsVariant: createGameModel.twoCorpsVariant,
      customCeos: createGameModel.customCeos,
      preludeDraftVariant: createGameModel.preludeDraftVariant,
      startingCeos: createGameModel.startingCeos,
      starWarsExpansion:
          createGameModel.selectedExpansions.contains(ExpansionType.STARWARS),
      underworldExpansion:
          createGameModel.selectedExpansions.contains(ExpansionType.UNDERWORLD),
    );
  }

  factory NewGameConfig.fromJson(Map<String, dynamic> e) {
    return NewGameConfig(
      players: (e['players'] as List<dynamic>)
          .map((e) => NewPlayerModel(
                index: e['index'] as int,
                userId: e['userId'] as String,
                name: e['name'] as String,
                color: PlayerColor.fromString(e['color'] as String),
                beginner: e['beginner'] as bool,
                handicap: e['handicap'] as int,
                first: e['first'] as bool,
              ))
          .toList(),
      maxPlayers: e['maxPlayers'] as int,
      prelude: e['prelude'] as bool,
      venusNext: e['venusNext'] as bool,
      colonies: e['colonies'] as bool,
      turmoil: e['turmoil'] as bool,
      board: BoardNameType.fromString(e['board'] as String),
      seed: e['seed'] as double,
      initialDraft: e['initialDraft'] as bool,
      randomFirstPlayer: e['randomFirstPlayer'] as bool,
      clonedGamedId: e['clonedGamedId'] != null
          ? GameId.fromString(e['clonedGamedId'] as String)
          : null,
      undoOption: e['undoOption'] as bool,
      showTimers: e['showTimers'] as bool,
      fastModeOption: e['fastModeOption'] as bool,
      showOtherPlayersVP: e['showOtherPlayersVP'] as bool,
      corporateEra: e['corporateEra'] as bool,
      prelude2Expansion: e['prelude2Expansion'] as bool,
      promoCardsOption: e['promoCardsOption'] as bool,
      communityCardsOption: e['communityCardsOption'] as bool,
      aresExtension: e['aresExtension'] as bool,
      politicalAgendasExtension:
          AgendaStyle.fromString(e['politicalAgendasExtension'] as String) ??
              AgendaStyle.STANDARD,
      solarPhaseOption: e['solarPhaseOption'] as bool,
      removeNegativeGlobalEventsOption:
          e['removeNegativeGlobalEventsOption'] as bool,
      includeVenusMA: e['includeVenusMA'] as bool,
      moonExpansion: e['moonExpansion'] as bool,
      pathfindersExpansion: e['pathfindersExpansion'] as bool,
      ceoExtension: e['ceoExtension'] as bool,
      draftVariant: e['draftVariant'] as bool,
      startingCorporations: e['startingCorporations'] as int,
      shuffleMapOption: e['shuffleMapOption'] as bool,
      randomMA: RandomMAOptionType.fromString(e['randomMA'] as String),
      includeFanMA: e['includeFanMA'] as bool,
      soloTR: e['soloTR'] as bool,
      customCorporationsList: (e['customCorporationsList'] as List<dynamic>)
          .map((e) => CardName.fromString(e as String))
          .cast<CardName>()
          .toList(),
      bannedCards: (e['bannedCards'] as List<dynamic>)
          .map((e) => CardName.fromString(e as String))
          .cast<CardName>()
          .toList(),
      includedCards: e['includedCards'] == null
          ? []
          : (e['includedCards'] as List<dynamic>)
              .map((e) => CardName.fromString(e as String))
              .cast<CardName>()
              .toList(),
      customColoniesList: (e['customColoniesList'] as List<dynamic>)
          .map((e) => ColonyName.fromString(e as String))
          .cast<ColonyName>()
          .toList(),
      customPreludes: (e['customPreludes'] as List<dynamic>)
          .map((e) => CardName.fromString(e as String))
          .cast<CardName>()
          .toList(),
      requiresMoonTrackCompletion: e['requiresMoonTrackCompletion'] as bool,
      requiresVenusTrackCompletion: e['requiresVenusTrackCompletion'] as bool,
      moonStandardProjectVariant: e['moonStandardProjectVariant'] as bool,
      altVenusBoard: e['altVenusBoard'] as bool,
      escapeVelocityMode: e['escapeVelocityMode'] as bool,
      escapeVelocityThreshold: e['escapeVelocityThreshold'] as int?,
      escapeVelocityBonusSeconds: e['escapeVelocityBonusSeconds'] as int?,
      escapeVelocityPeriod: e['escapeVelocityPeriod'] as int?,
      escapeVelocityPenalty: e['escapeVelocityPenalty'] as int?,
      twoCorpsVariant: e['twoCorpsVariant'] as bool,
      customCeos: (e['customCeos'] as List<dynamic>)
          .map((e) => CardName.fromString(e as String))
          .cast<CardName>()
          .toList(),
      preludeDraftVariant: e['preludeDraftVariant'] as bool?,
      startingCeos: e['startingCeos'] as int,
      starWarsExpansion: e['starWarsExpansion'] as bool,
      underworldExpansion: e['underworldExpansion'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((e) => e.toJson()).toList(),
      'maxPlayers': maxPlayers,
      'prelude': prelude,
      'venusNext': venusNext,
      'colonies': colonies,
      'turmoil': turmoil,
      'board': board.toString(),
      'seed': seed,
      'initialDraft': initialDraft,
      'randomFirstPlayer': randomFirstPlayer,
      if (clonedGamedId?.id != null) 'clonedGamedId': clonedGamedId.toString(),
      'undoOption': undoOption,
      'showTimers': showTimers,
      'fastModeOption': fastModeOption,
      'showOtherPlayersVP': showOtherPlayersVP,
      'corporateEra': corporateEra,
      'prelude2Expansion': prelude2Expansion,
      'promoCardsOption': promoCardsOption,
      'communityCardsOption': communityCardsOption,
      'aresExtension': aresExtension,
      'politicalAgendasExtension': politicalAgendasExtension.toString(),
      'solarPhaseOption': solarPhaseOption,
      'removeNegativeGlobalEventsOption': removeNegativeGlobalEventsOption,
      'includeVenusMA': includeVenusMA,
      'moonExpansion': moonExpansion,
      'pathfindersExpansion': pathfindersExpansion,
      'ceoExtension': ceoExtension,
      'draftVariant': draftVariant,
      'startingCorporations': startingCorporations,
      'shuffleMapOption': shuffleMapOption,
      'randomMA': randomMA.toString(),
      'includeFanMA': includeFanMA,
      'soloTR': soloTR,
      'customCorporationsList':
          customCorporationsList.map((e) => e.toString()).toList(),
      'bannedCards': bannedCards.map((e) => e.toString()).toList(),
      'includedCards': includedCards.map((e) => e.toString()).toList(),
      'customColoniesList':
          customColoniesList.map((e) => e.toString()).toList(),
      'customPreludes': customPreludes.map((e) => e.toString()).toList(),
      'requiresMoonTrackCompletion': requiresMoonTrackCompletion,
      'requiresVenusTrackCompletion': requiresVenusTrackCompletion,
      'moonStandardProjectVariant': moonStandardProjectVariant,
      'altVenusBoard': altVenusBoard,
      'escapeVelocityMode': escapeVelocityMode,
      'escapeVelocityThreshold': escapeVelocityThreshold,
      'escapeVelocityBonusSeconds': escapeVelocityBonusSeconds,
      'escapeVelocityPeriod': escapeVelocityPeriod,
      'escapeVelocityPenalty': escapeVelocityPenalty,
      'twoCorpsVariant': twoCorpsVariant,
      'customCeos': customCeos.map((e) => e.toString()).toList(),
      if (preludeDraftVariant != null)
        'preludeDraftVariant': preludeDraftVariant,
      'startingCeos': startingCeos,
      'starWarsExpansion': starWarsExpansion,
      'underworldExpansion': underworldExpansion,
    };
  }

  @override
  List<Object?> get props => [
        players,
        maxPlayers,
        prelude,
        venusNext,
        colonies,
        turmoil,
        board,
        seed,
        initialDraft,
        randomFirstPlayer,
        clonedGamedId,
        undoOption,
        showTimers,
        fastModeOption,
        showOtherPlayersVP,
        corporateEra,
        prelude2Expansion,
        promoCardsOption,
        communityCardsOption,
        aresExtension,
        politicalAgendasExtension,
        solarPhaseOption,
        removeNegativeGlobalEventsOption,
        includeVenusMA,
        moonExpansion,
        pathfindersExpansion,
        ceoExtension,
        draftVariant,
        startingCorporations,
        shuffleMapOption,
        randomMA,
        includeFanMA,
        soloTR,
        customCorporationsList,
        bannedCards,
        includedCards,
        customColoniesList,
        customPreludes,
        requiresMoonTrackCompletion,
        requiresVenusTrackCompletion,
        moonStandardProjectVariant,
        altVenusBoard,
        escapeVelocityMode,
        escapeVelocityThreshold,
        escapeVelocityBonusSeconds,
        escapeVelocityPeriod,
        escapeVelocityPenalty,
        twoCorpsVariant,
        customCeos,
        startingCeos,
        starWarsExpansion,
        underworldExpansion,
      ];
}
