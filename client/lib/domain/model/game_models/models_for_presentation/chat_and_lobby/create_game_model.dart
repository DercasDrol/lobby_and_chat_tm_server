import 'package:equatable/equatable.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/boards/BoardName.dart';
import 'package:mars_flutter/domain/model/boards/BoardNameType.dart';
import 'package:mars_flutter/domain/model/boards/RandomBoardOption.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/expansion_type.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/option_miniature_model.dart';
import 'package:mars_flutter/domain/model/ma/RandomMAOptionType.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';

class CreateGameModel extends Equatable {
  final int firstIndex;
  int get playersCount => players.length;
  final int maxPlayers;
  final List<NewPlayerModel> players;
  final bool draftVariant;
  final bool initialDraft;
  final RandomMAOptionType randomMA;
  final bool randomFirstPlayer;
  final bool showOtherPlayersVP;

  final bool showColoniesList;
  final bool showCorporationList;
  final bool showPreludesList;
  final bool showBannedCards;

  final List<ColonyName> customColonies;
  final List<CardName> customCorporations;
  final List<CardName> customPreludes;
  final List<CardName> bannedCards;
  final BoardNameType board;
  static const List<BoardNameType> boards = const [
    BoardName.THARSIS,
    BoardName.HELLAS,
    BoardName.ELYSIUM,
    RandomBoardOption.OFFICIAL,
    BoardName.ARABIA_TERRA,
    BoardName.AMAZONIS,
    BoardName.TERRA_CIMMERIA,
    BoardName.VASTITAS_BOREALIS,
    RandomBoardOption.ALL,
  ];
  final double seed;
  final bool seededGame;
  final bool solarPhaseOption;
  final bool shuffleMapOption;

  final List<ExpansionType> selectedExpansions;
  static final List<ExpansionType> expansions = ExpansionType.values.toList();
  final AgendaStyle politicalAgendasExtension;

  final bool undoOption;
  final bool showTimers;
  final bool fastModeOption;
  final bool removeNegativeGlobalEventsOption;
  final bool includeVenusMA;
  final bool includeFanMA;
  final int startingCorporations;
  final bool soloTR;
  final GameId? clonedGameId;
  final bool requiresVenusTrackCompletion;
  final bool requiresMoonTrackCompletion;
  final bool moonStandardProjectVariant;
  final bool altVenusBoard;
  final bool escapeVelocityMode;
  final int escapeVelocityThreshold;
  final int escapeVelocityBonusSeconds;
  final int escapeVelocityPeriod;
  final int escapeVelocityPenalty;
  final bool twoCorpsVariant;
  final List<CardName> customCeos;
  final int startingCeos;

  CreateGameModel({
    this.firstIndex = 0,
    this.players = const [],
    this.maxPlayers = 1,
    this.draftVariant = true,
    this.initialDraft = false,
    this.randomMA = RandomMAOptionType.NONE,
    this.randomFirstPlayer = true,
    this.showOtherPlayersVP = false,
    this.showColoniesList = false,
    this.showCorporationList = false,
    this.showPreludesList = false,
    this.showBannedCards = false,
    this.customColonies = const [],
    this.customCorporations = const [],
    this.customPreludes = const [],
    this.bannedCards = const [],
    this.board = BoardName.THARSIS,
    this.seed = 0.0,
    this.seededGame = false,
    this.solarPhaseOption = false,
    this.shuffleMapOption = false,
    this.politicalAgendasExtension = AgendaStyle.STANDARD,
    this.undoOption = false,
    this.showTimers = true,
    this.fastModeOption = false,
    this.removeNegativeGlobalEventsOption = false,
    this.includeVenusMA = true,
    this.includeFanMA = false,
    this.startingCorporations = 2,
    this.soloTR = false,
    this.clonedGameId,
    this.requiresVenusTrackCompletion = false,
    this.requiresMoonTrackCompletion = false,
    this.moonStandardProjectVariant = false,
    this.altVenusBoard = false,
    this.escapeVelocityMode = false,
    this.escapeVelocityThreshold = DEFAULT_ESCAPE_VELOCITY_THRESHOLD,
    this.escapeVelocityBonusSeconds = DEFAULT_ESCAPE_VELOCITY_BONUS_SECONDS,
    this.escapeVelocityPeriod = DEFAULT_ESCAPE_VELOCITY_PERIOD,
    this.escapeVelocityPenalty = DEFAULT_ESCAPE_VELOCITY_PENALTY,
    this.twoCorpsVariant = false,
    this.customCeos = const [],
    this.startingCeos = 3,
    this.selectedExpansions = const [ExpansionType.CORPORATE_ERA],
  });

  factory CreateGameModel.fromGameConfig(NewGameConfig gameConfig) {
    final firstIndex =
        gameConfig.players.indexWhere((element) => element.first);

    return CreateGameModel(
      firstIndex: firstIndex == -1 ? 0 : firstIndex,
      players: gameConfig.players,
      maxPlayers: gameConfig.maxPlayers,
      draftVariant: gameConfig.draftVariant,
      initialDraft: gameConfig.initialDraft,
      randomMA: gameConfig.randomMA,
      randomFirstPlayer: gameConfig.randomFirstPlayer,
      showOtherPlayersVP: gameConfig.showOtherPlayersVP,
      showColoniesList: gameConfig.customColoniesList.isNotEmpty,
      showCorporationList: gameConfig.customCorporationsList.isNotEmpty,
      showPreludesList: gameConfig.customPreludes.isNotEmpty,
      showBannedCards: gameConfig.bannedCards.isNotEmpty,
      customColonies: gameConfig.customColoniesList,
      customCorporations: gameConfig.customCorporationsList,
      customPreludes: gameConfig.customPreludes,
      bannedCards: gameConfig.bannedCards,
      board: gameConfig.board,
      seed: gameConfig.seed,
      seededGame: gameConfig.clonedGamedId != null,
      solarPhaseOption: gameConfig.solarPhaseOption,
      shuffleMapOption: gameConfig.shuffleMapOption,
      politicalAgendasExtension: gameConfig.politicalAgendasExtension,
      undoOption: gameConfig.undoOption,
      showTimers: gameConfig.showTimers,
      fastModeOption: gameConfig.fastModeOption,
      removeNegativeGlobalEventsOption:
          gameConfig.removeNegativeGlobalEventsOption,
      includeVenusMA: gameConfig.includeVenusMA,
      includeFanMA: gameConfig.includeFanMA,
      startingCorporations: gameConfig.startingCorporations,
      soloTR: gameConfig.soloTR,
      clonedGameId: gameConfig.clonedGamedId,
      requiresVenusTrackCompletion: gameConfig.requiresVenusTrackCompletion,
      requiresMoonTrackCompletion: gameConfig.requiresMoonTrackCompletion,
      moonStandardProjectVariant: gameConfig.moonStandardProjectVariant,
      altVenusBoard: gameConfig.altVenusBoard,
      escapeVelocityMode: gameConfig.escapeVelocityMode,
      escapeVelocityThreshold: gameConfig.escapeVelocityThreshold ??
          DEFAULT_ESCAPE_VELOCITY_THRESHOLD,
      escapeVelocityBonusSeconds: gameConfig.escapeVelocityBonusSeconds ??
          DEFAULT_ESCAPE_VELOCITY_BONUS_SECONDS,
      escapeVelocityPeriod:
          gameConfig.escapeVelocityPeriod ?? DEFAULT_ESCAPE_VELOCITY_PERIOD,
      escapeVelocityPenalty:
          gameConfig.escapeVelocityPenalty ?? DEFAULT_ESCAPE_VELOCITY_PENALTY,
      twoCorpsVariant: gameConfig.twoCorpsVariant,
      customCeos: gameConfig.customCeos,
      startingCeos: gameConfig.startingCeos,
      selectedExpansions: [
        if (gameConfig.corporateEra) ExpansionType.CORPORATE_ERA,
        if (gameConfig.prelude) ...[ExpansionType.PRELUDE] else ...[],
        if (gameConfig.prelude2Expansion) ExpansionType.PRELUDE2,
        if (gameConfig.venusNext) ExpansionType.VENUS_NEXT,
        if (gameConfig.colonies) ExpansionType.COLONIES,
        if (gameConfig.turmoil) ExpansionType.TURMOIL,
        if (gameConfig.promoCardsOption) ExpansionType.PROMO,
        if (gameConfig.aresExtension) ExpansionType.ARES,
        if (gameConfig.communityCardsOption) ExpansionType.COMMUNITY,
        if (gameConfig.moonExpansion) ExpansionType.MOON,
        if (gameConfig.pathfindersExpansion) ExpansionType.PATHFINDERS,
        if (gameConfig.ceoExtension) ExpansionType.CEO,
        if (gameConfig.starWarsExpansion) ExpansionType.STARWARS,
        if (gameConfig.underworldExpansion) ExpansionType.UNDERWORLD,
      ],
    );
  }

  List<OptionMiniatureModel> get selectedOptionsMiniatures {
    return [
      //officialExpansions
      if (selectedExpansions.contains(ExpansionType.CORPORATE_ERA))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconCorporateEra.path,
        ),
      if (selectedExpansions.contains(ExpansionType.PRELUDE))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconPrelude.path,
          //additionalOptions: twoCorpsVariant ? '(Merger)' : null,
        ),
      if (selectedExpansions.contains(ExpansionType.PRELUDE2))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconPrelude2.path,
        ),
      if (selectedExpansions.contains(ExpansionType.VENUS_NEXT))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconVenus.path,
          //additionalOptions: altVenusBoard ? '(Alt)' : null,
        ),
      if (selectedExpansions.contains(ExpansionType.COLONIES))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconColonies.path,
        ),
      if (selectedExpansions.contains(ExpansionType.TURMOIL))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconTurmoil.path,
          //additionalOptions: removeNegativeGlobalEventsOption ? '(RNGE)' : null,
        ),

      if (selectedExpansions.contains(ExpansionType.PROMO))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconPromo.path,
        ),

      //funExpansions
      if (selectedExpansions.contains(ExpansionType.ARES))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconAres.path,
        ),
      if (selectedExpansions.contains(ExpansionType.COMMUNITY))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconCommunity.path,
        ),
      if (selectedExpansions.contains(ExpansionType.MOON))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconThemoon.path,
          //additionalOptions: (moonStandardProjectVariant ||
          //        requiresMoonTrackCompletion)
          //    ? "(${(moonStandardProjectVariant ? 'SPV, ' : '') + (requiresMoonTrackCompletion ? 'MMT' : '')})"
          //    : null,
        ),
      if (politicalAgendasExtension != AgendaStyle.STANDARD)
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconAgendas.path,
          //additionalOptions: "(${politicalAgendasExtension.toString()})",
        ),
      if (selectedExpansions.contains(ExpansionType.PATHFINDERS))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconPathfinders.path,
        ),

      if (selectedExpansions.contains(ExpansionType.CEO))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconCeo.path,
          //additionalOptions: '($startingCeos)',
        ),

      if (selectedExpansions.contains(ExpansionType.STARWARS))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconStarwars.path,
        ),

      if (selectedExpansions.contains(ExpansionType.UNDERWORLD))
        OptionMiniatureModel(
          icon: Assets.expansionIcons.expansionIconUnderworld.path,
        ),
    ];
  }

  CreateGameModel copyWith({
    int? firstIndex,
    int? playersCount,
    List<NewPlayerModel>? players,
    int? maxPlayers,
    bool? draftVariant,
    bool? initialDraft,
    RandomMAOptionType? randomMA,
    bool? randomFirstPlayer,
    bool? showOtherPlayersVP,
    bool? showColoniesList,
    bool? showCorporationList,
    bool? showPreludesList,
    bool? showBannedCards,
    List<ColonyName>? customColonies,
    List<CardName>? customCorporations,
    List<CardName>? customPreludes,
    List<CardName>? bannedCards,
    BoardNameType? board,
    double? seed,
    bool? seededGame,
    bool? solarPhaseOption,
    bool? shuffleMapOption,
    List<ExpansionType>? selectedExpansions,
    AgendaStyle? politicalAgendasExtension,
    bool? undoOption,
    bool? showTimers,
    bool? fastModeOption,
    bool? removeNegativeGlobalEventsOption,
    bool? includeVenusMA,
    bool? includeFanMA,
    int? startingCorporations,
    bool? soloTR,
    GameId? clonedGameId,
    bool? requiresVenusTrackCompletion,
    bool? requiresMoonTrackCompletion,
    bool? moonStandardProjectVariant,
    bool? altVenusBoard,
    bool? escapeVelocityMode,
    int? escapeVelocityThreshold,
    int? escapeVelocityBonusSeconds,
    int? escapeVelocityPeriod,
    int? escapeVelocityPenalty,
    bool? twoCorpsVariant,
    List<CardName>? customCeos,
    int? startingCeos,
  }) {
    return CreateGameModel(
      firstIndex: firstIndex ?? this.firstIndex,
      players: players ?? this.players,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      draftVariant: draftVariant ?? this.draftVariant,
      initialDraft: initialDraft ?? this.initialDraft,
      randomMA: randomMA ?? this.randomMA,
      randomFirstPlayer: randomFirstPlayer ?? this.randomFirstPlayer,
      showOtherPlayersVP: showOtherPlayersVP ?? this.showOtherPlayersVP,
      showColoniesList: showColoniesList ?? this.showColoniesList,
      showCorporationList: showCorporationList ?? this.showCorporationList,
      showPreludesList: showPreludesList ?? this.showPreludesList,
      showBannedCards: showBannedCards ?? this.showBannedCards,
      customColonies: customColonies ?? this.customColonies,
      customCorporations: customCorporations ?? this.customCorporations,
      customPreludes: customPreludes ?? this.customPreludes,
      bannedCards: bannedCards ?? this.bannedCards,
      board: board ?? this.board,
      seed: seed ?? this.seed,
      seededGame: seededGame ?? this.seededGame,
      solarPhaseOption: solarPhaseOption ?? this.solarPhaseOption,
      shuffleMapOption: shuffleMapOption ?? this.shuffleMapOption,
      selectedExpansions: selectedExpansions ?? this.selectedExpansions,
      politicalAgendasExtension:
          politicalAgendasExtension ?? this.politicalAgendasExtension,
      undoOption: undoOption ?? this.undoOption,
      showTimers: showTimers ?? this.showTimers,
      fastModeOption: fastModeOption ?? this.fastModeOption,
      removeNegativeGlobalEventsOption: removeNegativeGlobalEventsOption ??
          this.removeNegativeGlobalEventsOption,
      includeVenusMA: includeVenusMA ?? this.includeVenusMA,
      includeFanMA: includeFanMA ?? this.includeFanMA,
      startingCorporations: startingCorporations ?? this.startingCorporations,
      soloTR: soloTR ?? this.soloTR,
      clonedGameId: clonedGameId ?? this.clonedGameId,
      requiresVenusTrackCompletion:
          requiresVenusTrackCompletion ?? this.requiresVenusTrackCompletion,
      requiresMoonTrackCompletion:
          requiresMoonTrackCompletion ?? this.requiresMoonTrackCompletion,
      moonStandardProjectVariant:
          moonStandardProjectVariant ?? this.moonStandardProjectVariant,
      altVenusBoard: altVenusBoard ?? this.altVenusBoard,
      escapeVelocityMode: escapeVelocityMode ?? this.escapeVelocityMode,
      escapeVelocityThreshold:
          escapeVelocityThreshold ?? this.escapeVelocityThreshold,
      escapeVelocityBonusSeconds:
          escapeVelocityBonusSeconds ?? this.escapeVelocityBonusSeconds,
      escapeVelocityPeriod: escapeVelocityPeriod ?? this.escapeVelocityPeriod,
      escapeVelocityPenalty:
          escapeVelocityPenalty ?? this.escapeVelocityPenalty,
      twoCorpsVariant: twoCorpsVariant ?? this.twoCorpsVariant,
      customCeos: customCeos ?? this.customCeos,
      startingCeos: startingCeos ?? this.startingCeos,
    );
  }

  @override
  List<Object?> get props => [
        firstIndex,
        playersCount,
        players,
        maxPlayers,
        draftVariant,
        initialDraft,
        randomMA,
        randomFirstPlayer,
        showOtherPlayersVP,
        showColoniesList,
        showCorporationList,
        showPreludesList,
        showBannedCards,
        customColonies,
        customCorporations,
        customPreludes,
        bannedCards,
        board,
        seed,
        seededGame,
        solarPhaseOption,
        shuffleMapOption,
        selectedExpansions,
        politicalAgendasExtension,
        undoOption,
        showTimers,
        fastModeOption,
        removeNegativeGlobalEventsOption,
        includeVenusMA,
        includeFanMA,
        startingCorporations,
        soloTR,
        clonedGameId,
        requiresVenusTrackCompletion,
        requiresMoonTrackCompletion,
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
      ];
}
