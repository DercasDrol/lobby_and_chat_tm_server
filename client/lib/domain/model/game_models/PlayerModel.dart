import 'package:equatable/equatable.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/Phase.dart';
import 'package:mars_flutter/domain/model/Resource.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/card/ITagCount.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/domain/model/game/IVictoryPointsBreakdown.dart';
import 'package:mars_flutter/domain/model/game_models/ActionLabel.dart';
import 'package:mars_flutter/domain/model/game_models/CardModel.dart';
import 'package:mars_flutter/domain/model/game_models/GameModel.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerInputModel.dart';
import 'package:mars_flutter/domain/model/game_models/TimerModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_logs_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_ma_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_button_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_option_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_planet_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_player_panel_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tag_info.dart';

import 'package:mars_flutter/domain/model/inputs/InputResponse.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';
import 'package:mars_flutter/domain/model/ma/AwardName.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneName.dart';

class ViewModel extends Equatable {
  final GameModel game;
  final List<PublicPlayerModel> players;
  final ParticipantId id;
  final PublicPlayerModel? thisPlayer;

  ViewModel({
    required this.game,
    required this.players,
    required this.id,
    required this.thisPlayer,
  });

  bool get isContainsWaitingFor => false;

  List<MilestoneName>? get _availableMilestones => null;

  List<AwardName>? get _availableAwards => null;
  List<MilestoneName>? get availableMilestone => null;
  PlayerColor? get thisPlayerColor =>
      thisPlayer == null ? null : thisPlayer!.color;

  factory ViewModel.fromJson(Map<String, dynamic> json) {
    return ParticipantId.fromString(json['id']).runtimeType == PlayerId
        ? PlayerViewModel.fromJson(json)
        : ViewModel(
            game: GameModel.fromJson(json['game']),
            players: (json['players'] as List)
                .map((player) => PublicPlayerModel.fromJson(player))
                .toList(),
            id: ParticipantId.fromString(json['id']),
            thisPlayer: json['thisPlayer'] != null
                ? PublicPlayerModel.fromJson(json['thisPlayer'])
                : null,
          );
  }

  ActionLabel _getActionLabel(PublicPlayerModel player) {
    if (this.game.phase == Phase.DRAFTING) {
      if (player.needsToDraft ?? false) {
        return ActionLabel.DRAFTING;
      } else {
        return ActionLabel.NONE;
      }
    } else if (this.game.phase == Phase.RESEARCH) {
      if (player.needsToResearch ?? false) {
        return ActionLabel.RESEARCHING;
      } else {
        return ActionLabel.NONE;
      }
    }
    if (this.game.passedPlayers.contains(player.color)) {
      return ActionLabel.PASSED;
    }
    if (player.isActive) return ActionLabel.ACTIVE;
    final notPassedPlayers = this
        .players
        .where(
          (PublicPlayerModel p) => !this.game.passedPlayers.contains(p.color),
        )
        .toList();

    final currentPlayerIndex = notPassedPlayers.indexOf(player);

    if (currentPlayerIndex == -1) {
      return ActionLabel.NONE;
    }

    final prevPlayerIndex = currentPlayerIndex == 0
        ? notPassedPlayers.length - 1
        : currentPlayerIndex - 1;
    final isNext = notPassedPlayers[prevPlayerIndex].isActive;
    const SHOW_NEXT_LABEL_MIN = 2;
    if (isNext && this.players.length > SHOW_NEXT_LABEL_MIN) {
      return ActionLabel.NEXT;
    }

    return ActionLabel.NONE;
  }

  @override
  List<Object?> get props => [game, players, id, thisPlayer];

  PresentationTabsInfo _getProjectCardsTabsInfo({
    required playerColor,
    required List<CardModel> playedCards,
    required Future<void> Function(InputResponse p1) sendPlayerAction,
    required void Function(String) onUserError,
  }) =>
      PresentationTabsInfo(
        playerColor: PlayerColor.NEUTRAL,
        rightTabInfo:
            PresentationTabInfo(cards: playedCards, tabTitle: 'Played cards'),
      );

  int _getAllCardsDiscount({
    required final PublicPlayerModel player,
  }) =>
      player.tableau.fold(
        0,
        (previousValue, card) =>
            card.discount?.fold(
              previousValue,
              (previousValue0, e0) =>
                  (previousValue0 ?? 0) +
                  (e0.tag == null && e0.per == null ? e0.amount : 0),
            ) ??
            previousValue,
      );

  List<TagInfo> _getTagInfo({
    required final PublicPlayerModel player,
  }) =>
      Tag.values
          .where((tag) =>
              (game.gameOptions.venusNextExtension ? true : tag != Tag.VENUS) &&
              (game.gameOptions.pathfindersExpansion
                  ? true
                  : tag != Tag.MARS && tag != Tag.CLONE) &&
              (game.gameOptions.moonExpansion ? true : tag != Tag.MOON))
          .map(
            (e) => TagInfo(
              tag: e,
              count: player.tags.fold(
                0,
                (previousValue, tag) =>
                    tag.tag == e ? tag.count : previousValue,
              ),
              discont: player.tableau.fold(
                0,
                (previousValue, card) =>
                    card.discount?.fold(
                      previousValue,
                      (previousValue0, e0) =>
                          (previousValue0 ?? 0) + (e0.tag == e ? e0.amount : 0),
                    ) ??
                    previousValue,
              ),
            ),
          )
          .toList();

  PresentationPlayerPanelInfo getPresentationPlayerPanelInfo({
    required final PublicPlayerModel player,
    required Future<void> Function(InputResponse p1) sendPlayerAction,
    required void Function(String) onUserError,
    required PresentationPlanetInfoCN planetInfo,
  }) {
    return PresentationPlayerPanelInfo(
      playerState: player,
      passedPlayers: this.game.passedPlayers,
      actionLabel: this._getActionLabel(player),
      showFirstMark: this.players[0].color == player.color,
      availableActionsCount: player.availableBlueCardActionCount,
      actionsOnCardsTabsInfo: null,
      projectCardsTabsInfo: this._getProjectCardsTabsInfo(
        playerColor: player.color,
        playedCards: player.tableau,
        sendPlayerAction: sendPlayerAction,
        onUserError: onUserError,
      ),
      tagsInfo: _getTagInfo(player: player),
      allCardsDiscount: _getAllCardsDiscount(player: player),
    );
  }

  PresentationPlanetInfoCN getPlanetInfo(
          {required Future<void> Function(InputResponse inputResponse)
              sendPlayerAction}) =>
      PresentationPlanetInfoCN(
        onConfirm: null,
        spaceModels: this.game.spaces,
        availableSpaces: null,
      );

  PresentationMaInfo getAwardsInfo(
          {required Future<void> Function(InputResponse inputResponse)
              sendPlayerAction,
          required final PresentationLogsInfo? logs}) =>
      PresentationMaInfo(
          ma: this.game.awards,
          availableMa: this._availableAwards,
          onConfirm: null,
          playerAwardsOrder: logs?.playedAwardsOrger);

  PresentationMaInfo getMilestonesInfo(
          {required Future<void> Function(InputResponse inputResponse)
              sendPlayerAction}) =>
      PresentationMaInfo(
        onConfirm: null,
        ma: this.game.milestones,
        availableMa: this._availableMilestones,
      );
}

// 'off': Resources (or production) are unprotected.
// 'on': Resources (or production) are protected.
// 'half': Half resources are protected when targeted. Applies to Botanical Experience.
enum Protection {
  OFF,
  ON,
  HALF;

  static const _TO_STRING_MAP = {
    OFF: 'off',
    ON: 'on',
    HALF: 'half',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}

/** The public information about a player */
final class PublicPlayerModel extends Equatable {
  final int actionsTakenThisRound;
  final List<CardName> actionsThisGeneration;
  final int actionsTakenThisGame;
  final int availableBlueCardActionCount;
  final int cardCost;
  final int cardDiscount;
  final int cardsInHandNbr;
  final int citiesCount;
  final int coloniesCount;
  final PlayerColor color;
  final int energy;
  final int energyProduction;
  final int fleetSize;
  final int heat;
  final int heatProduction;
  final PlayerId? id;
  final int influence;
  final bool isActive;
  final CardName? lastCardPlayed;
  final int megaCredits;
  final int megaCreditProduction;
  final String name;
  final bool? needsToDraft;
  final bool? needsToResearch;
  final int noTagsCount;
  final int plants;
  final int plantProduction;
  final Map<Resource, Protection> protectedResources;
  final Map<Resource, Protection> protectedProduction;
  final List<CardModel> tableau;
  final List<CardModel> selfReplicatingRobotsCards;
  final int steel;
  final int steelProduction;
  final int steelValue;
  final List<ITagCount> tags;
  final int terraformRating;
  final TimerModel timer;
  final int titanium;
  final int titaniumProduction;
  final int titaniumValue;
  final int tradesThisGeneration;
  final IVictoryPointsBreakdown victoryPointsBreakdown;
  final List<int> victoryPointsByGeneration;

  PublicPlayerModel({
    required this.actionsTakenThisRound,
    required this.actionsThisGeneration,
    required this.actionsTakenThisGame,
    required this.availableBlueCardActionCount,
    required this.cardCost,
    required this.cardDiscount,
    required this.cardsInHandNbr,
    required this.citiesCount,
    required this.coloniesCount,
    required this.color,
    required this.energy,
    required this.energyProduction,
    required this.fleetSize,
    required this.heat,
    required this.heatProduction,
    required this.id,
    required this.influence,
    required this.isActive,
    required this.lastCardPlayed,
    required this.megaCredits,
    required this.megaCreditProduction,
    required this.name,
    required this.needsToDraft,
    required this.needsToResearch,
    required this.noTagsCount,
    required this.plants,
    required this.plantProduction,
    required this.protectedResources,
    required this.protectedProduction,
    required this.tableau,
    required this.selfReplicatingRobotsCards,
    required this.steel,
    required this.steelProduction,
    required this.steelValue,
    required this.tags,
    required this.terraformRating,
    required this.timer,
    required this.titanium,
    required this.titaniumProduction,
    required this.titaniumValue,
    required this.tradesThisGeneration,
    required this.victoryPointsBreakdown,
    required this.victoryPointsByGeneration,
  });

  factory PublicPlayerModel.fromJson(Map<String, dynamic> json) {
    return PublicPlayerModel(
      actionsTakenThisRound: json['actionsTakenThisRound'] as int,
      actionsThisGeneration: (json['actionsThisGeneration'])
          .map((e) => CardName.fromString(e.toString()))
          .cast<CardName>()
          .toList(),
      actionsTakenThisGame: json['actionsTakenThisGame'] as int,
      availableBlueCardActionCount: json['availableBlueCardActionCount'] as int,
      cardCost: json['cardCost'] as int,
      cardDiscount: json['cardDiscount'] as int,
      cardsInHandNbr: json['cardsInHandNbr'] as int,
      citiesCount: json['citiesCount'] as int,
      coloniesCount: json['coloniesCount'] as int,
      color: PlayerColor.fromString(json['color']),
      energy: json['energy'] as int,
      energyProduction: json['energyProduction'] as int,
      fleetSize: json['fleetSize'] as int,
      heat: json['heat'] as int,
      heatProduction: json['heatProduction'] as int,
      id: json['id'] != null ? PlayerId.fromString(json['id'] as String) : null,
      influence: json['influence'] as int,
      isActive: json['isActive'] as bool,
      lastCardPlayed: json['lastCardPlayed'] != null
          ? CardName.fromString(json['lastCardPlayed'] as String)
          : null,
      megaCredits: json['megaCredits'] as int,
      megaCreditProduction: json['megaCreditProduction'] as int,
      name: json['name'] as String,
      needsToDraft: json['needsToDraft'] as bool?,
      needsToResearch: json['needsToResearch'] as bool?,
      noTagsCount: json['noTagsCount'] as int,
      plants: json['plants'] as int,
      plantProduction: json['plantProduction'] as int,
      protectedResources: (json['protectedResources'] as Map<String, dynamic>)
          .map((k, e) =>
              MapEntry(Resource.fromString(k), Protection.fromString(e))),
      protectedProduction: (json['protectedProduction'] as Map<String, dynamic>)
          .map((k, e) =>
              MapEntry(Resource.fromString(k), Protection.fromString(e))),
      tableau: (json['tableau'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      selfReplicatingRobotsCards: (json['selfReplicatingRobotsCards'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      steel: json['steel'] as int,
      steelProduction: json['steelProduction'] as int,
      steelValue: json['steelValue'] as int,
      tags: (json['tags'])
          .map((e) => ITagCount.fromJson(e as Map<String, dynamic>))
          .cast<ITagCount>()
          .toList(),
      terraformRating: json['terraformRating'] as int,
      timer: TimerModel.fromJson(json['timer'] as Map<String, dynamic>),
      titanium: json['titanium'] as int,
      titaniumProduction: json['titaniumProduction'] as int,
      titaniumValue: json['titaniumValue'] as int,
      tradesThisGeneration: json['tradesThisGeneration'] as int,
      victoryPointsBreakdown: IVictoryPointsBreakdown.fromJson(
          json['victoryPointsBreakdown'] as Map<String, dynamic>),
      victoryPointsByGeneration:
          (json['victoryPointsByGeneration'] as List<dynamic>)
              .map((e) => e as int)
              .toList(),
    );
  }

  @override
  List<Object?> get props => [
        actionsTakenThisRound,
        actionsThisGeneration,
        actionsTakenThisGame,
        availableBlueCardActionCount,
        cardCost,
        cardDiscount,
        cardsInHandNbr,
        citiesCount,
        coloniesCount,
        color,
        energy,
        energyProduction,
        fleetSize,
        heat,
        heatProduction,
        id,
        influence,
        isActive,
        lastCardPlayed,
        megaCredits,
        megaCreditProduction,
        name,
        needsToDraft,
        needsToResearch,
        noTagsCount,
        plants,
        plantProduction,
        protectedResources,
        protectedProduction,
        tableau,
        selfReplicatingRobotsCards,
        steel,
        steelProduction,
        steelValue,
        tags,
        terraformRating,
        timer,
        titanium,
        titaniumProduction,
        titaniumValue,
        tradesThisGeneration,
        victoryPointsBreakdown,
        victoryPointsByGeneration,
      ];
}
/** A player's view of the game, including their secret information. */

class PlayerViewModel extends ViewModel {
  final List<CardModel> _cardsInHand;
  final List<CardModel> dealtCorporationCards;
  final List<CardModel> dealtPreludeCards;
  final List<CardModel> dealtProjectCards;
  final List<CardModel> dealtCeoCards;
  final List<CardModel> draftedCorporations;
  final List<CardModel> draftedCards;
  @override
  final PlayerId id;
  final List<CardModel> ceoCardsInHand;
  final List<CardModel> pickedCorporationCard;
  final List<CardModel> preludeCardsInHand;
  @override
  final PublicPlayerModel thisPlayer;
  final PlayerInputModel? waitingFor;

  PlayerViewModel({
    required List<CardModel> cardsInHand,
    required this.dealtCorporationCards,
    required this.dealtPreludeCards,
    required this.dealtProjectCards,
    required this.dealtCeoCards,
    required this.draftedCorporations,
    required this.draftedCards,
    required this.id,
    required this.ceoCardsInHand,
    required this.pickedCorporationCard,
    required this.preludeCardsInHand,
    required this.thisPlayer,
    required this.waitingFor,
    required super.game,
    required super.players,
  })  : _cardsInHand = cardsInHand,
        super(thisPlayer: thisPlayer, id: id);

  factory PlayerViewModel.fromJson(Map<String, dynamic> json) {
    return PlayerViewModel(
      game: GameModel.fromJson(json['game']),
      players: (json['players'] as List)
          .map((player) => PublicPlayerModel.fromJson(player))
          .toList(),
      cardsInHand: (json['cardsInHand'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      dealtCorporationCards: (json['dealtCorporationCards'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      dealtPreludeCards: (json['dealtPreludeCards'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      dealtProjectCards: (json['dealtProjectCards'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      dealtCeoCards: (json['dealtCeoCards'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      draftedCorporations: (json['draftedCorporations'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      draftedCards: (json['draftedCards'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      id: PlayerId.fromString(json['id'] as String),
      ceoCardsInHand: (json['ceoCardsInHand'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      pickedCorporationCard: (json['pickedCorporationCard'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      preludeCardsInHand: (json['preludeCardsInHand'])
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .cast<CardModel>()
          .toList(),
      thisPlayer: PublicPlayerModel.fromJson(
          json['thisPlayer'] as Map<String, dynamic>),
      waitingFor: json['waitingFor'] == null
          ? null
          : PlayerInputModel.fromJson(
              json['waitingFor'] as Map<String, dynamic>),
    );
  }

  @override
  bool get isContainsWaitingFor => this.waitingFor != null;

  @override
  List<MilestoneName>? get _availableMilestones => this.isContainsWaitingFor
      ? this.waitingFor!.getAvailableMilestones()
      : null;

  @override
  List<AwardName>? get _availableAwards =>
      this.isContainsWaitingFor ? this.waitingFor!.getAvailableAwards() : null;

  PresentationTabsInfo? _getCardsToSelectTabsInfo({
    required Future<void> Function(InputResponse inputResponse)
        sendPlayerAction,
    List<TagInfo>? tagsDiscounts,
    int? allCardsDiscount,
  }) {
    final PlayerInputModel? inputModelCardsToSelect = this.isContainsWaitingFor
        ? this.waitingFor!.inputModelCardsToSelect()
        : null;
    if (!this._isInitialGameStage && inputModelCardsToSelect != null ||
        (this.game.phase == Phase.DRAFTING && this.draftedCards.isNotEmpty)) {
      final int minCards = inputModelCardsToSelect?.min ?? 1;
      final int maxCards = inputModelCardsToSelect?.max ?? 1;
      return PresentationTabsInfo(
        allCardsDiscount: allCardsDiscount,
        tagsDiscounts: tagsDiscounts,
        rightTabInfo: PresentationTabInfo(
          cards: inputModelCardsToSelect?.cards ?? [],
          tabTitle:
              inputModelCardsToSelect?.title.toString() ?? "Drafted cards",
          disabledCards: this.draftedCards,
          minCards: minCards,
          maxCards: maxCards,
          showDiscount: true,
        ),
        playerColor: this.thisPlayer.color,
        getMegacreditsCounters: (actionInfo) =>
            this.isContainsWaitingFor && this.game.phase != Phase.DRAFTING
                ? [
                    MegacreditsCounter(
                        counter: actionInfo.rightTabCards.length *
                            this.thisPlayer.cardCost)
                  ]
                : null,
        getOnConfirmButtonFn: (actionInfo) => () {
          logger.d("rightTabCards: ${actionInfo.rightTabCards}");
          var resp = this.isContainsWaitingFor
              ? this.waitingFor!.getInputResponseSelectedCards(
                  actionInfo.rightTabCards.map((e) => e.name).toList())
              : null;
          if (resp != null) sendPlayerAction(resp);
        },
        getConfirmButtonText: (actionInfo) {
          return actionInfo.rightTabCards.length >= minCards &&
                  actionInfo.rightTabCards.length <= maxCards
              ? inputModelCardsToSelect?.buttonLabel == null
                  ? null
                  : inputModelCardsToSelect!.buttonLabel +
                      " " +
                      actionInfo.rightTabCards.length.toString()
              : null;
        },
      );
    } else {
      return null;
    }
  }

  PresentationTabsInfo? _getOptionsTabsInfo(
    Future<void> Function(InputResponse) saveFn,
  ) {
    PlayerInputModel? getInputModelOptions = this.isContainsWaitingFor
        ? this.waitingFor!.getInputModelOptions()
        : null;

    final List<PresentationOptionInfo>? options = getInputModelOptions
        ?.getOptionsList()
        ?.map((e) => PresentationOptionInfo(
            buttonLabel: e.buttonLabel, title: e.title.toString()))
        .cast<PresentationOptionInfo>()
        .toList();
    if (options == null || options.isEmpty) {
      return null;
    } else {
      return PresentationTabsInfo(
          playerColor: thisPlayer.color,
          rightTabInfo: PresentationTabInfo(
            tabTitle:
                getInputModelOptions?.title.toString() ?? 'Available options',
            options: options,
          ),
          getOnConfirmButtonFn: (actionInfo) => () {
                final int? optionIndx = actionInfo.optionIndx;
                if (optionIndx != null && optionIndx < options.length) {
                  final InputResponse? resp = this
                      .waitingFor
                      ?.getInputResponseSelectedOptions(
                          options[optionIndx].title);
                  resp == null ? null : saveFn(resp);
                }
              },
          getConfirmButtonText: (actionInfo) {
            final int? optionIndx = actionInfo.optionIndx;
            return optionIndx != null && optionIndx < options.length
                ? options[optionIndx].buttonLabel
                : null;
          });
    }
  }

  /**Initial game stage block */
  int _getMkCountAfterPreludes(
      CardName corpName, List<CardModel> preludeCards, int selectedCardsCount) {
    int result = 0;
    preludeCards.forEach((prelude) {
      final card = ClientCard.fromCardName(prelude.name);
      result += card.startingMegaCredits ?? 0;

      switch (corpName) {
        // For each step you increase the production of a resource ... you also gain that resource.
        case CardName.MANUTECH:
          result += card.productionBox?.megacredits ?? 0;
          break;

        // When you place a city tile, gain 3 M€.
        case CardName.THARSIS_REPUBLIC:
          switch (prelude.name) {
            case CardName.SELF_SUFFICIENT_SETTLEMENT:
            case CardName.EARLY_SETTLEMENT:
            case CardName.STRATEGIC_BASE_PLANNING:
              result += 3;
              break;
            default:
              break;
          }
          break;

        // When ANY microbe tag is played ... lose 4 M€ or as much as possible.
        case CardName.PHARMACY_UNION:
          final int tagsCount =
              card.tags.where((tag) => tag == Tag.MICROBE).length;
          result -= (4 * tagsCount);
          break;

        // when a microbe tag is played, incl. this, THAT PLAYER gains 2 M€,
        case CardName.SPLICE:
          final int tagsCount =
              card.tags.where((tag) => tag == Tag.MICROBE).length;
          result += (2 * tagsCount);
          break;

        // Whenever Venus is terraformed 1 step, you gain 2 M€
        case CardName.APHRODITE:
          switch (prelude.name) {
            case CardName.VENUS_FIRST:
            case CardName.VENUS_FIRST_PATHFINDERS:
              result += 4;
              break;
            case CardName.HYDROGEN_BOMBARDMENT:
              result += 2;
              break;
            default:
              break;
          }
          break;

        // When any player raises any Moon Rate, gain 1M€ per step.
        case CardName.LUNA_FIRST_INCORPORATED:
          switch (prelude.name) {
            case CardName.FIRST_LUNAR_SETTLEMENT:
            case CardName.CORE_MINE:
            case CardName.BASIC_INFRASTRUCTURE:
              result += 1;
              break;
            case CardName.MINING_COMPLEX:
              result += 2;
              break;
            default:
              break;
          }
          break;

        // When you place an ocean tile, gain 4MC
        case CardName.POLARIS:
          switch (prelude.name) {
            case CardName.AQUIFER_TURBINES:
            case CardName.POLAR_INDUSTRIES:
              result += 4;
              break;
            case CardName.GREAT_AQUIFER:
              result += 8;
              break;
            default:
              break;
          }
          break;
        // Gain 2 MC for each project card in hand.
        case CardName.HEAD_START:
          result += selectedCardsCount * 2;
          break;
        default:
          break;
      }
    });
    return result;
  }

  bool get _isInitialGameStage => this.waitingFor?.isInitialGameStage ?? false;

  List<CardModel>? get _availableInitialCards =>
      this.waitingFor?.getAvailableInitialCards();

  List<CardModel>? get _availableInitialCorpCards => this.isContainsWaitingFor
      ? this.waitingFor!.getAvailableInitialCorpCards()
      : null;

  List<CardModel>? get _availableInitialPreludeCards =>
      this.isContainsWaitingFor
          ? this.waitingFor!.availableInitialPreludeCards()
          : null;

  PresentationTabsInfo? _getInitialChoiceTabsInfo(
      Future<void> Function(InputResponse) sendPlayerAction) {
    if (this._isInitialGameStage) {
      return PresentationTabsInfo(
        rightTabInfo: PresentationTabInfo(
          tabTitle: 'Select initial cards to buy',
          cards: this._availableInitialCards ?? [],
          minCards: 0,
          maxCards: (this._availableInitialCards ?? []).length,
        ),
        leftTabInfo: PresentationTabInfo(
          tabTitle: 'Select corporation',
          cards: this._availableInitialCorpCards ?? [],
          minCards: 1,
          maxCards: 1,
        ),
        midleTabInfo: PresentationTabInfo(
          tabTitle: 'Select 2 Prelude cards',
          cards: this._availableInitialPreludeCards ?? [],
          minCards: 2,
          maxCards: 2,
        ),
        playerColor: this.thisPlayer.color,
        getMegacreditsCounters: (actionInfo) {
          final ClientCard? corp = actionInfo.leftTabCards.length > 0
              ? ClientCard.fromCardName(actionInfo.leftTabCards.first.name)
              : null;
          final cardCost = corp?.cardCost ?? this.thisPlayer.cardCost;
          final startingMk = (corp?.startingMegaCredits ?? 0) -
              actionInfo.rightTabCards.length * cardCost;
          final int? mkAfterPrelude =
              corp == null || actionInfo.midleTabCards == null
                  ? null
                  : _getMkCountAfterPreludes(
                      corp.name,
                      actionInfo.midleTabCards!,
                      actionInfo.rightTabCards.length);
          return [
            MegacreditsCounter(
              counter: startingMk,
              counterLable: "Starting Megacredits:",
            ),
            ...(mkAfterPrelude != null
                ? [
                    MegacreditsCounter(
                      counter: mkAfterPrelude + startingMk,
                      counterLable: "After Preludes:",
                    )
                  ]
                : [])
          ];
        },
        getOnConfirmButtonFn: (actionInfo) {
          if (actionInfo.leftTabCards.length > 0 &&
              (actionInfo.midleTabCards?.length ?? 2) == 2) {
            return () {
              final InputResponse? resp = this
                  .waitingFor!
                  .getInputResponseInitialChoice(actionInfo.leftTabCards,
                      actionInfo.rightTabCards, actionInfo.midleTabCards);

              if (resp != null) sendPlayerAction(resp);
            };
          } else {
            return null;
          }
        },
        getConfirmButtonText: (actionInfo) => actionInfo.tabIndex ==
                    (actionInfo.midleTabCards == null ? 1 : 2) &&
                actionInfo.leftTabCards.length > 0 &&
                (actionInfo.midleTabCards?.length ?? 2) == 2
            ? "Start Game with ${actionInfo.rightTabCards.length.toString()} project cards"
            : null,
      );
    } else {
      return null;
    }
  }

/**End of Initial game stage block */

/**Player panel block */
  T? _prepareOnlyThisPlayerData<T>(
      PlayerColor playerColor, T Function() param) {
    return thisPlayer.color == playerColor ? param() : null;
  }

  @override
  PresentationPlayerPanelInfo getPresentationPlayerPanelInfo({
    required final PublicPlayerModel player,
    required Future<void> Function(InputResponse p1) sendPlayerAction,
    required void Function(String) onUserError,
    required PresentationPlanetInfoCN planetInfo,
  }) {
    final List<TagInfo> tagsDiscounts = _getTagInfo(player: player);
    final int allCardsDiscount = _getAllCardsDiscount(player: player);
    return PresentationPlayerPanelInfo(
      playerState: player,
      actionLabel: this._getActionLabel(player),
      passedPlayers: this.game.passedPlayers,
      showFirstMark: player.color == this.players[0].color,
      availableActionsCount: player.availableBlueCardActionCount,
      actionsOnCardsTabsInfo: _prepareOnlyThisPlayerData<PresentationTabsInfo?>(
        player.color,
        () => this._getActionsOnCardsTabsInfo(player, sendPlayerAction),
      ),
      projectCardsTabsInfo: _getProjectCardsTabsInfo(
        playerColor: player.color,
        playedCards: player.tableau,
        sendPlayerAction: sendPlayerAction,
        onUserError: onUserError,
        tagsDiscounts: tagsDiscounts,
        allCardsDiscount: allCardsDiscount,
      ),
      passButtonInfo: _prepareOnlyThisPlayerData<PresentationButtonInfo?>(
          player.color, () => this._getPassButtonInfo(sendPlayerAction)),
      skipButtonInfo: _prepareOnlyThisPlayerData<PresentationButtonInfo?>(
          player.color, () => this._getSkipButtonInfo(sendPlayerAction)),
      standartProjectsTabsInfo:
          _prepareOnlyThisPlayerData<PresentationTabsInfo?>(
        player.color,
        () => this._getStandartProjectsTabsInfo(
          sendPlayerAction: sendPlayerAction,
          onUserError: onUserError,
        ),
      ),
      paymentTabsInfo: _prepareOnlyThisPlayerData<PresentationTabsInfo?>(
          player.color, () => this._getPaymentTabInfo(sendPlayerAction)),
      optionsTabsInfo: _prepareOnlyThisPlayerData<PresentationTabsInfo?>(
          player.color, () => this._getOptionsTabsInfo(sendPlayerAction)),
      initialTabsInfo: _prepareOnlyThisPlayerData<PresentationTabsInfo?>(
          player.color, () => this._getInitialChoiceTabsInfo(sendPlayerAction)),
      cardsToSelectTabsInfo: _prepareOnlyThisPlayerData<PresentationTabsInfo?>(
          player.color,
          () => this._getCardsToSelectTabsInfo(
                sendPlayerAction: sendPlayerAction,
                tagsDiscounts: tagsDiscounts,
                allCardsDiscount: allCardsDiscount,
              )),
      heatIncreaseButtonInfo:
          _prepareOnlyThisPlayerData<PresentationButtonInfo?>(player.color,
              () => this._getHeatIncreaseButtonInfo(sendPlayerAction)),
      greeneryPlacementButtonInfo:
          _prepareOnlyThisPlayerData<PresentationButtonInfo?>(
              player.color,
              () => this._getGreeneryPlacementButtonInfo(
                  sendPlayerAction, planetInfo)),
      tagsInfo: tagsDiscounts,
      allCardsDiscount: allCardsDiscount,
    );
  }

  PresentationButtonInfo? _getHeatIncreaseButtonInfo(
    Future<void> Function(InputResponse) saveFn,
  ) {
    final InputResponse? response =
        this.waitingFor?.getInputResponseHeatIncrease();
    return response == null
        ? null
        : PresentationButtonInfo(onConfirmButtonFn: () => saveFn(response));
  }

  PresentationButtonInfo? _getGreeneryPlacementButtonInfo(
    Future<void> Function(InputResponse) saveFn,
    PresentationPlanetInfoCN planetInfo,
  ) {
    List<SpaceId>? availableSpaces =
        this.waitingFor?.getAvailableSpaces("plants into greenery");
    return availableSpaces == null
        ? null
        : PresentationButtonInfo(onConfirmButtonFn: () {
            planetInfo.availableSpaces = availableSpaces;
            planetInfo.onConfirm = (SpaceId spaceId) {
              final InputResponse? response = this
                  .waitingFor
                  ?.getInputResponseSpace(spaceId, "plants into greenery");
              response == null ? null : saveFn(response);
            };
          });
  }

  PaymentInfo _getPaymentModelByCard(
      CardModel card, PlayerInputModel inputModelProjectCardsToPlay) {
    final List<Tag> tags = ClientCard.fromCardName(card.name).tags;
    final bool canUseHeat = inputModelProjectCardsToPlay.canUseHeat ?? false;
    final bool canUseSteel = tags.contains(Tag.BUILDING) ||
        this.thisPlayer.lastCardPlayed == CardName.LAST_RESORT_INGENUITY;
    final bool canUseTitanium = tags.contains(Tag.SPACE) ||
        this.thisPlayer.lastCardPlayed == CardName.LAST_RESORT_INGENUITY;

    final bool canUseLunaTradeFederationTitanium =
        inputModelProjectCardsToPlay.canUseLunaTradeFederationTitanium ?? false;
    final int? microbes = inputModelProjectCardsToPlay.microbes;
    final bool canUseMicrobes = microbes != null && tags.contains(Tag.PLANT);
    final int? floaters = inputModelProjectCardsToPlay.floaters;
    final bool canUseFloaters = floaters != null && tags.contains(Tag.VENUS);
    final int? lunaArchivesScience =
        inputModelProjectCardsToPlay.lunaArchivesScience;
    final bool canUseLunaArchivesScience =
        lunaArchivesScience != null && tags.contains(Tag.MOON);
    final int? spireScience = inputModelProjectCardsToPlay.spireScience;
    final bool canUseSpireScience =
        spireScience != null && tags.contains(Tag.MOON);
    final int? seeds = inputModelProjectCardsToPlay.seeds;
    final bool canUseSeeds = seeds != null &&
        (tags.contains(Tag.PLANT) ||
            card.name == CardName.GREENERY_STANDARD_PROJECT);
    final int? kuiperAsteroids = inputModelProjectCardsToPlay.kuiperAsteroids;
    final bool canUseAsteroids = kuiperAsteroids != null;
    final int? graphene = inputModelProjectCardsToPlay.graphene;
    final bool canUseGraphene = graphene != null;
    return PaymentInfo(
      targetSum: card.calculatedCost ?? 0,
      steelValue: this.thisPlayer.steelValue,
      titaniumValue: !canUseTitanium && canUseLunaTradeFederationTitanium
          ? this.thisPlayer.titaniumValue - 1
          : this.thisPlayer.titaniumValue,
      availablePayment: Payment(
        megaCredits: thisPlayer.megaCredits,
        heat: canUseHeat ? thisPlayer.heat : 0,
        steel: canUseSteel ? thisPlayer.steel : 0,
        titanium: canUseTitanium ||
                (!canUseTitanium && canUseLunaTradeFederationTitanium)
            ? thisPlayer.titanium
            : 0,
        microbes: canUseMicrobes ? microbes : 0,
        floaters: canUseFloaters ? floaters : 0,
        lunaArchivesScience:
            canUseLunaArchivesScience ? lunaArchivesScience : 0,
        spireScience: canUseSpireScience ? spireScience : 0,
        seeds: canUseSeeds ? seeds : 0,
        auroraiData: 0, //I'm not sure where it may be used
        graphene: canUseGraphene ? graphene : 0,
        kuiperAsteroids: canUseAsteroids ? kuiperAsteroids : 0,
      ),
    );
  }

  PresentationTabsInfo _getProjectCardsTabsInfo({
    required playerColor,
    required List<CardModel> playedCards,
    required Future<void> Function(InputResponse p1) sendPlayerAction,
    required void Function(String) onUserError,
    List<TagInfo>? tagsDiscounts,
    int? allCardsDiscount,
  }) {
    final PlayerInputModel? inputModelProjectCardsToPlay =
        this.isContainsWaitingFor
            ? this.waitingFor!.getInputModelProjectCardsToPlay()
            : null;
    final List<CardModel>? _availableCardsForPlay =
        inputModelProjectCardsToPlay?.cards;
    return PresentationTabsInfo(
      leftTabInfo: _prepareOnlyThisPlayerData<PresentationTabInfo>(
        playerColor,
        () => PresentationTabInfo(
          tabTitle: inputModelProjectCardsToPlay?.title.toString() ??
              'Play project card',
          cards: _availableCardsForPlay,
          disabledCards: _availableCardsForPlay == null
              ? this._cardsInHand
              : this
                  ._cardsInHand
                  .toSet()
                  .difference(_availableCardsForPlay.toSet())
                  .toList(),
          minCards: 1,
          maxCards: 1,
          showDiscount: true,
        ),
      ),
      rightTabInfo: PresentationTabInfo(
        tabTitle: 'Played cards',
        cards: playedCards,
      ),
      playerColor: playerColor,
      getPaymentInfo: (actionInfo) {
        if (actionInfo.leftTabCards.length > 0 &&
            inputModelProjectCardsToPlay != null) {
          final CardModel card = actionInfo.leftTabCards.first;
          return _getPaymentModelByCard(card, inputModelProjectCardsToPlay);
        } else {
          return null;
        }
      },
      getOnConfirmButtonFn: (actionInfo) => actionInfo.payment == null ||
              actionInfo.leftTabCards.length < 1
          ? null
          : () {
              logger.d(
                  "Debud: leftTabCards: ${actionInfo.leftTabCards}, rightTabCards: ${actionInfo.rightTabCards}");
              final CardModel card = actionInfo.leftTabCards.first;
              var resp = this.isContainsWaitingFor && actionInfo.payment != null
                  ? this.waitingFor!.getInputResponseSelectedProjectCard(
                      card.name, actionInfo.payment!)
                  : null;
              resp == null
                  ? onUserError("Something went wrong")
                  : sendPlayerAction(resp);
            },
      getConfirmButtonText: (actionInfo) =>
          actionInfo.tabIndex == 0 && !actionInfo.leftTabCards.isEmpty
              ? inputModelProjectCardsToPlay?.buttonLabel
              : null,
      tagsDiscounts: tagsDiscounts,
      allCardsDiscount: allCardsDiscount,
    );
  }

  PresentationTabsInfo? _getActionsOnCardsTabsInfo(
    PublicPlayerModel player,
    Future<void> Function(InputResponse) saveFn,
  ) {
    final PlayerInputModel? inputModelActionsOnCards = this.isContainsWaitingFor
        ? this.waitingFor!.getInputModelActions()
        : null;
    return inputModelActionsOnCards == null
        ? null
        : PresentationTabsInfo(
            playerColor: player.color,
            rightTabInfo: _prepareOnlyThisPlayerData<PresentationTabInfo>(
              player.color,
              () => PresentationTabInfo(
                tabTitle: inputModelActionsOnCards.title?.toString() ?? " ",
                cards: inputModelActionsOnCards.cards ?? [],
                maxCards: 1,
                minCards: 1,
              ),
            ),
            getOnConfirmButtonFn: (actionInfo) => () {
              if (actionInfo.rightTabCards.length > 0) {
                final InputResponse? resp = this
                    .waitingFor
                    ?.getInputResponseActionCards(
                        actionInfo.rightTabCards.first.name);
                if (resp != null) saveFn(resp);
              }
            },
            getConfirmButtonText: (actionInfo) =>
                actionInfo.tabIndex == 0 && !actionInfo.rightTabCards.isEmpty
                    ? inputModelActionsOnCards.buttonLabel
                    : null,
          );
  }

  /**End player panel block */

  /**Start of Standart projects block */
  PresentationTabsInfo? _getStandartProjectsTabsInfo({
    required Future<void> Function(InputResponse p1) sendPlayerAction,
    required void Function(String) onUserError,
  }) {
    final PlayerInputModel? inputModelStandartProjects =
        this.isContainsWaitingFor
            ? this.waitingFor!.getInputModelStandartProjects()
            : null;
    final List<CardModel>? _standartProjects =
        inputModelStandartProjects?.cards;
    final PlayerInputModel? inputModelSellPatents = this.isContainsWaitingFor
        ? this.waitingFor!.getInputModelSellPatents()
        : null;
    final List<CardModel>? _availableCardsForCell =
        inputModelSellPatents?.cards;
    return _standartProjects == null
        ? null
        : PresentationTabsInfo(
            playerColor: PlayerColor.NEUTRAL,
            leftTabInfo: PresentationTabInfo(
              tabTitle: inputModelStandartProjects?.title.toString() ?? " ",
              cards: (_standartProjects)
                  .where((e) => !(e.isDisabled ?? false))
                  .toList(),
              disabledCards: (_standartProjects)
                  .where((e) => (e.isDisabled ?? false))
                  .toList(),
              minCards: inputModelStandartProjects?.min,
              maxCards: inputModelStandartProjects?.max,
            ),
            rightTabInfo: PresentationTabInfo(
              tabTitle: 'Sell patents',
              cards: _availableCardsForCell ?? [],
              minCards: inputModelSellPatents?.min,
              maxCards: inputModelSellPatents?.max,
            ),
            getOnConfirmButtonFn: (actionInfo) {
              logger.d(
                  "Debud: lTabCards: ${actionInfo.leftTabCards}, rTabCards: ${actionInfo.rightTabCards}");
              if (actionInfo.tabIndex == 0) {
                return () {
                  if (!actionInfo.leftTabCards.isEmpty) {
                    final CardModel card = actionInfo.leftTabCards.first;
                    final InputResponse? response = this.isContainsWaitingFor
                        ? this
                            .waitingFor!
                            .getInputResponseSelectedStandartProject(card.name)
                        : null;
                    response == null
                        ? onUserError("Something went wrong")
                        : sendPlayerAction(response);
                  }
                };
              } else if (actionInfo.tabIndex == 1) {
                return () {
                  if (!actionInfo.rightTabCards.isEmpty) {
                    final InputResponse? response = this.isContainsWaitingFor
                        ? this.waitingFor!.getInputResponseSelectedSellPatents(
                            actionInfo.rightTabCards
                                .map((e) => e.name)
                                .toList())
                        : null;
                    response == null
                        ? onUserError("Something went wrong")
                        : sendPlayerAction(response);
                  }
                };
              } else {
                return null;
              }
            },
            getConfirmButtonText: (actionInfo) {
              if (actionInfo.tabIndex == 0)
                return actionInfo.leftTabCards.isEmpty
                    ? null
                    : inputModelStandartProjects?.buttonLabel;
              else if (actionInfo.tabIndex == 1)
                return actionInfo.rightTabCards.isEmpty
                    ? null
                    : (inputModelSellPatents?.buttonLabel ?? " ") +
                        ": " +
                        actionInfo.rightTabCards.length.toString();
              else
                return null;
            },
          );
  }

  /**End of Standart projects block */
  @override
  PresentationMaInfo getAwardsInfo(
          {required Future<void> Function(InputResponse inputResponse)
              sendPlayerAction,
          required final PresentationLogsInfo? logs}) =>
      PresentationMaInfo(
          ma: this.game.awards,
          availableMa: this._availableAwards,
          onConfirm: (String ma) {
            final InputResponse? response =
                this.waitingFor?.getInputResponseSelectedMA(ma);
            response == null ? null : sendPlayerAction(response);
          },
          playerAwardsOrder: logs?.playedAwardsOrger);

  @override
  PresentationMaInfo getMilestonesInfo(
          {required Future<void> Function(InputResponse inputResponse)
              sendPlayerAction}) =>
      PresentationMaInfo(
        ma: this.game.milestones,
        availableMa: this._availableMilestones,
        onConfirm: (String ma) {
          final InputResponse? response =
              this.waitingFor?.getInputResponseSelectedMA(ma);
          response == null ? null : sendPlayerAction(response);
        },
      );

/**Planet block */
  PresentationPlanetInfoCN getPlanetInfo(
      {required Future<void> Function(InputResponse inputResponse)
          sendPlayerAction}) {
    final bool passIsAvailable =
        this.waitingFor?.getOnConfirmPassButtonText() == null;
    return PresentationPlanetInfoCN(
      onConfirm: passIsAvailable
          ? (SpaceId spaceId) {
              final InputResponse? response =
                  this.waitingFor?.getInputResponseSpace(spaceId, null);
              response == null ? null : sendPlayerAction(response);
            }
          : null,
      spaceModels: this.game.spaces,
      availableSpaces:
          passIsAvailable ? this.waitingFor?.getAvailableSpaces(null) : null,
      activePlayer: thisPlayerColor,
    );
  }

/**Pass buttons block */
  PresentationButtonInfo? _getPassButtonInfo(
    Future<void> Function(InputResponse) saveFn,
  ) {
    final InputResponse? response = this.waitingFor?.getInputResponsePass();
    final String? buttonText = this.waitingFor?.getOnConfirmPassButtonText();
    return response == null || buttonText == null
        ? null
        : PresentationButtonInfo(
            onConfirmButtonFn: () => saveFn(response),
            buttonText: buttonText,
          );
  }

  PresentationButtonInfo? _getSkipButtonInfo(
    Future<void> Function(InputResponse) saveFn,
  ) {
    final InputResponse? response = this.waitingFor?.getInputResponseSkip();
    final String? buttonText = this.waitingFor?.getOnConfirmSkipButtonText();
    return response == null || buttonText == null
        ? null
        : PresentationButtonInfo(
            onConfirmButtonFn: () => saveFn(response),
            buttonText: buttonText,
          );
  }
/** end Pass buttons block */

  PresentationTabsInfo? _getPaymentTabInfo(
    Future<void> Function(InputResponse) saveFn,
  ) =>
      !(this.waitingFor?.isPaymentAvailable() ?? false)
          ? null
          : PresentationTabsInfo(
              getPaymentInfo: (actionInfo) => PaymentInfo(
                targetSum: this.waitingFor?.amount ?? 0,
                steelValue: thisPlayer.steelValue,
                titaniumValue: thisPlayer.titaniumValue,
                availablePayment: Payment(
                  megaCredits: thisPlayer.megaCredits,
                  heat: this.waitingFor?.canUseHeat ?? false
                      ? thisPlayer.heat
                      : 0,
                  steel: this.waitingFor?.canUseSteel ?? false
                      ? thisPlayer.steel
                      : 0,
                  titanium: this.waitingFor?.canUseTitanium ?? false
                      ? thisPlayer.titanium
                      : 0,
                  microbes: this.waitingFor?.microbes ?? 0,
                  floaters: this.waitingFor?.floaters ?? 0,
                  lunaArchivesScience:
                      this.waitingFor?.lunaArchivesScience ?? 0,
                  seeds: this.waitingFor?.seeds ?? 0,
                  auroraiData: this.waitingFor?.auroraiData ?? 0,
                  graphene: this.waitingFor?.graphene ?? 0,
                  kuiperAsteroids: this.waitingFor?.kuiperAsteroids ?? 0,
                  spireScience: this.waitingFor?.spireScience ?? 0,
                ),
              ),
              getOnConfirmButtonFn: (actionInfo) {
                final Payment? payment = actionInfo.payment;
                if (payment != null)
                  return () {
                    final InputResponse? response =
                        this.waitingFor?.getInputResponsePay(
                              payment,
                            );
                    response == null ? null : saveFn(response);
                  };
                return null;
              },
              getConfirmButtonText: (actionInfo) =>
                  this.waitingFor?.buttonLabel ?? "Pay",
              rightTabInfo: PresentationTabInfo(
                  tabTitle: this.waitingFor?.title?.message ?? "Pay"),
              playerColor: thisPlayer.color,
            );
}
