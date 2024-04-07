import 'package:equatable/equatable.dart';
import 'package:mars_flutter/domain/model/boards/BoardName.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/ma/RandomMAOptionType.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';

class GameOptionsModel extends Equatable {
  final bool aresExtension;
  final bool altVenusBoard;
  final BoardName boardName;
  final List<CardName> bannedCards;
  final bool ceoExtension;
  final bool coloniesExtension;
  final bool communityCardsOption;
  final bool corporateEra;
  final bool draftVariant;
  final bool escapeVelocityMode;
  final int? escapeVelocityThreshold;
  final int? escapeVelocityPeriod;
  final int? escapeVelocityPenalty;
  final bool fastModeOption;
  final bool includeFanMA;
  final bool includeVenusMA;
  final bool initialDraftVariant;
  final bool moonExpansion;
  final bool pathfindersExpansion;
  final bool preludeExtension;
  final bool promoCardsOption;
  final AgendaStyle politicalAgendasExtension;
  final bool removeNegativeGlobalEvents;
  final bool showOtherPlayersVP;
  final bool showTimers;
  final bool shuffleMapOption;
  final bool solarPhaseOption;
  final bool soloTR;
  final RandomMAOptionType randomMA;
  final bool requiresMoonTrackCompletion;
  final bool requiresVenusTrackCompletion;
  final bool turmoilExtension;
  final bool twoCorpsVariant;
  final bool venusNextExtension;
  final bool undoOption;

  GameOptionsModel({
    required this.aresExtension,
    required this.altVenusBoard,
    required this.boardName,
    required this.bannedCards,
    required this.ceoExtension,
    required this.coloniesExtension,
    required this.communityCardsOption,
    required this.corporateEra,
    required this.draftVariant,
    required this.escapeVelocityMode,
    this.escapeVelocityThreshold,
    this.escapeVelocityPeriod,
    this.escapeVelocityPenalty,
    required this.fastModeOption,
    required this.includeFanMA,
    required this.includeVenusMA,
    required this.initialDraftVariant,
    required this.moonExpansion,
    required this.pathfindersExpansion,
    required this.preludeExtension,
    required this.promoCardsOption,
    required this.politicalAgendasExtension,
    required this.removeNegativeGlobalEvents,
    required this.showOtherPlayersVP,
    required this.showTimers,
    required this.shuffleMapOption,
    required this.solarPhaseOption,
    required this.soloTR,
    required this.randomMA,
    required this.requiresMoonTrackCompletion,
    required this.requiresVenusTrackCompletion,
    required this.turmoilExtension,
    required this.twoCorpsVariant,
    required this.venusNextExtension,
    required this.undoOption,
  });

  static GameOptionsModel fromJson(Map<String, dynamic> json) {
    return GameOptionsModel(
      aresExtension: json['aresExtension'] as bool,
      altVenusBoard: json['altVenusBoard'] as bool,
      boardName: BoardName.fromString(json['boardName'] as String),
      bannedCards: json['bannedCards']
          .map((e) => CardName.fromString(e as String))
          .cast<CardName>()
          .toList(),
      ceoExtension: json['ceoExtension'] as bool,
      coloniesExtension: json['coloniesExtension'] as bool,
      communityCardsOption: json['communityCardsOption'] as bool,
      corporateEra: json['corporateEra'] as bool,
      draftVariant: json['draftVariant'] as bool,
      escapeVelocityMode: json['escapeVelocityMode'] as bool,
      escapeVelocityThreshold: json['escapeVelocityThreshold'] as int?,
      escapeVelocityPeriod: json['escapeVelocityPeriod'] as int?,
      escapeVelocityPenalty: json['escapeVelocityPenalty'] as int?,
      fastModeOption: json['fastModeOption'] as bool,
      includeFanMA: json['includeFanMA'] as bool,
      includeVenusMA: json['includeVenusMA'] as bool,
      initialDraftVariant: json['initialDraftVariant'] as bool,
      moonExpansion: json['moonExpansion'] as bool,
      pathfindersExpansion: json['pathfindersExpansion'] as bool,
      preludeExtension: json['preludeExtension'] as bool,
      promoCardsOption: json['promoCardsOption'] as bool,
      politicalAgendasExtension:
          AgendaStyle.fromString(json['politicalAgendasExtension'] as String) ??
              AgendaStyle.STANDARD,
      removeNegativeGlobalEvents: json['removeNegativeGlobalEvents'] as bool,
      showOtherPlayersVP: json['showOtherPlayersVP'] as bool,
      showTimers: json['showTimers'] as bool,
      shuffleMapOption: json['shuffleMapOption'] as bool,
      solarPhaseOption: json['solarPhaseOption'] as bool,
      soloTR: json['soloTR'] as bool,
      randomMA: RandomMAOptionType.fromString(json['randomMA'] as String),
      requiresMoonTrackCompletion: json['requiresMoonTrackCompletion'] as bool,
      requiresVenusTrackCompletion:
          json['requiresVenusTrackCompletion'] as bool,
      turmoilExtension: json['turmoilExtension'] as bool,
      twoCorpsVariant: json['twoCorpsVariant'] as bool,
      venusNextExtension: json['venusNextExtension'] as bool,
      undoOption: json['undoOption'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aresExtension': aresExtension,
      'altVenusBoard': altVenusBoard,
      'boardName': boardName.toString(),
      'bannedCards': bannedCards.map((e) => e.toString()).toList(),
      'ceoExtension': ceoExtension,
      'coloniesExtension': coloniesExtension,
      'communityCardsOption': communityCardsOption,
      'corporateEra': corporateEra,
      'draftVariant': draftVariant,
      'escapeVelocityMode': escapeVelocityMode,
      'escapeVelocityThreshold': escapeVelocityThreshold,
      'escapeVelocityPeriod': escapeVelocityPeriod,
      'escapeVelocityPenalty': escapeVelocityPenalty,
      'fastModeOption': fastModeOption,
      'includeFanMA': includeFanMA,
      'includeVenusMA': includeVenusMA,
      'initialDraftVariant': initialDraftVariant,
      'moonExpansion': moonExpansion,
      'pathfindersExpansion': pathfindersExpansion,
      'preludeExtension': preludeExtension,
      'promoCardsOption': promoCardsOption,
      'politicalAgendasExtension': politicalAgendasExtension.toString(),
      'removeNegativeGlobalEvents': removeNegativeGlobalEvents,
      'showOtherPlayersVP': showOtherPlayersVP,
      'showTimers': showTimers,
      'shuffleMapOption': shuffleMapOption,
      'solarPhaseOption': solarPhaseOption,
      'soloTR': soloTR,
      'randomMA': randomMA.toString(),
      'requiresMoonTrackCompletion': requiresMoonTrackCompletion,
      'requiresVenusTrackCompletion': requiresVenusTrackCompletion,
      'turmoilExtension': turmoilExtension,
      'twoCorpsVariant': twoCorpsVariant,
      'venusNextExtension': venusNextExtension,
      'undoOption': undoOption,
    };
  }

  @override
  List<Object?> get props => [
        aresExtension,
        altVenusBoard,
        boardName,
        bannedCards,
        ceoExtension,
        coloniesExtension,
        communityCardsOption,
        corporateEra,
        draftVariant,
        escapeVelocityMode,
        escapeVelocityThreshold,
        escapeVelocityPeriod,
        escapeVelocityPenalty,
        fastModeOption,
        includeFanMA,
        includeVenusMA,
        initialDraftVariant,
        moonExpansion,
        pathfindersExpansion,
        preludeExtension,
        promoCardsOption,
        politicalAgendasExtension,
        removeNegativeGlobalEvents,
        showOtherPlayersVP,
        showTimers,
        shuffleMapOption,
        solarPhaseOption,
        soloTR,
        randomMA,
        requiresMoonTrackCompletion,
        requiresVenusTrackCompletion,
        turmoilExtension,
        twoCorpsVariant,
        venusNextExtension,
        undoOption,
      ];
}
