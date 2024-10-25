import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/TileType.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/Units.dart';
import 'package:mars_flutter/domain/model/ares/AresData.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/colonies/ColonyName.dart';
import 'package:mars_flutter/domain/model/game_models/CardModel.dart';
import 'package:mars_flutter/domain/model/game_models/ColonyModel.dart';
import 'package:mars_flutter/domain/model/game_models/PayProductionUnitsModel.dart';
import 'package:mars_flutter/domain/model/game_models/TurmoilModel.dart';
import 'package:mars_flutter/domain/model/input/PlayerInputType.dart';
import 'package:mars_flutter/domain/model/inputs/AresGlobalParametersResponse.dart';
import 'package:mars_flutter/domain/model/inputs/InputResponse.dart';
import 'package:mars_flutter/domain/model/inputs/Payment.dart';
import 'package:mars_flutter/domain/model/logs/Message.dart';
import 'package:mars_flutter/domain/model/ma/AwardName.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneName.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';

//This is a info about what can to do player in current game state
class PlayerInputModel {
  int? amount;
  List<SpaceId>? spaces;
  List<CardModel>? cards;
  PlayerInputType type;
  List<PlayerInputModel>? options;
  PaymentOptions? paymentOptions;
  int? min;
  int? max;
  bool? maxByDefault;
  int? microbes;
  int? floaters;
  int? lunaArchivesScience;
  int? spireScience;
  int? seeds;
  int? auroraiData;
  int? graphene;
  int? kuiperAsteroids;
  List<PlayerColor>? players;
  Message? title;
  String buttonLabel;
  List<ColonyModel>? coloniesModel;
  PayProductionModel? payProduction;
  AresData? aresData;
  bool? selectBlueCardAction;
  bool? showOnlyInLearnerMode;
  bool? showOwner;
  List<PartyName>? parties;
  TurmoilModel? turmoil;
  List<TileType>? tiles;
  bool? showReset;

  PlayerInputModel({
    this.amount,
    this.spaces,
    this.paymentOptions,
    this.cards,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.maxByDefault,
    this.microbes,
    this.floaters,
    this.lunaArchivesScience,
    this.spireScience,
    this.seeds,
    this.auroraiData,
    this.players,
    this.title,
    required this.buttonLabel,
    this.coloniesModel,
    this.payProduction,
    this.aresData,
    this.selectBlueCardAction,
    this.showOnlyInLearnerMode,
    this.showOwner,
    this.parties,
    this.turmoil,
    this.tiles,
    this.showReset,
    this.graphene,
  });

  bool get isInitialGameStage => this.type == PlayerInputType.INITIAL_CARDS;

  static fromJson(Map<String, dynamic> json) {
    return PlayerInputModel(
      amount: json['amount'] as int?,
      spaces: json['spaces'] == null
          ? null
          : json['spaces']
              .map((e) => SpaceId.fromString(e as String))
              .cast<SpaceId>()
              .toList(),
      paymentOptions: json['paymentOptions'] == null
          ? null
          : PaymentOptions.fromJson(
              json['paymentOptions'] as Map<String, dynamic>),
      cards: json['cards'] == null
          ? null
          : json['cards']
              .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
              .cast<CardModel>()
              .toList(),
      type: PlayerInputType.fromString(json['type'] as String),
      options: json['options'] == null
          ? null
          : json['options']
              .map((e) => PlayerInputModel.fromJson(e as Map<String, dynamic>))
              .cast<PlayerInputModel>()
              .toList(),
      min: json['min'] as int?,
      max: json['max'] as int?,
      maxByDefault: json['maxByDefault'] as bool?,
      microbes: json['microbes'] as int?,
      floaters: json['floaters'] as int?,
      lunaArchivesScience: json['lunaArchivesScience'] as int?,
      spireScience: json['spireScience'] as int?,
      seeds: json['seeds'] as int?,
      auroraiData: json['auroraiData'] as int?,
      graphene: json['graphene'] as int?,
      players: json['players'] == null
          ? null
          : json['players']
              .map((e) => PlayerColor.fromString(e as String))
              .cast<PlayerColor>()
              .toList(),
      title: json['title'].runtimeType == String
          ? Message(message: json['title'] as String)
          : Message.fromJson(json['title'] as Map<String, dynamic>),
      buttonLabel: json['buttonLabel'] as String,
      coloniesModel: json['coloniesModel'] == null
          ? null
          : json['coloniesModel']
              .map((e) => ColonyModel.fromJson(e as Map<String, dynamic>))
              .cast<ColonyModel>()
              .toList(),
      payProduction: json['payProduction'] == null
          ? null
          : PayProductionModel.fromJson(
              json['payProduction'] as Map<String, dynamic>),
      aresData: json['aresData'] == null
          ? null
          : AresData.fromJson(json['aresData'] as Map<String, dynamic>),
      selectBlueCardAction: json['selectBlueCardAction'] as bool?,
      showOnlyInLearnerMode: json['showOnlyInLearnerMode'] as bool?,
      showOwner: json['showOwner'] as bool?,
      parties: json['parties'] == null
          ? null
          : json['parties']
              .map((e) => PartyName.fromString(e as String))
              .cast<PartyName>()
              .toList(),
      turmoil: json['turmoil'] == null
          ? null
          : TurmoilModel.fromJson(json['turmoil'] as Map<String, dynamic>),
      tiles: json['tiles'] == null
          ? null
          : json['tiles']
              .map((e) => TileType.fromString(e as String))
              .cast<TileType>()
              .toList(),
      showReset: json['showReset'] as bool?,
    );
  }

  static PlayerInputModel? _findInputModelByInputType(
    PlayerInputModel inputModel,
    PlayerInputType type,
    bool selectBlueCardAction,
    String? title,
  ) {
    var checkModel =
        _getCheckModelFn(inputModel, type, selectBlueCardAction, title);
    return checkModel(inputModel)
        ? inputModel
        : inputModel.options != null
            ? inputModel.options!.fold<PlayerInputModel?>(null,
                (PlayerInputModel? acc, PlayerInputModel element) {
                if (checkModel(element))
                  return element;
                else if (element.options != null) {
                  final res = _findInputModelByInputType(
                      element, type, selectBlueCardAction, title);
                  return res ?? acc;
                } else {
                  return acc;
                }
              })
            : null;
  }

  static InputResponse? _inputResponseByPlayerInputModel({
    required PlayerInputModel inputModel,
    List<CardName>? cards,
    List<CardName>? corpCards,
    int? number,
    Payment? payment,
    SpaceId? spaceId,
    PlayerColor? player,
    PartyName? partyName,
    ColonyName? colonyName,
    Units? units,
    AresGlobalParametersResponse? aresResponse,
    required bool Function(PlayerInputModel inputModel) isTargetInputModelFn,
    List<CardName>? preludeCards,
    Map<String, int>? amounts,
  }) {
    switch (inputModel.type) {
      case PlayerInputType.OPTION:
        return isTargetInputModelFn(inputModel) ? SelectOptionResponse() : null;
      case PlayerInputType.INITIAL_CARDS:
        List<InputResponse>? responses = inputModel.options
            ?.fold<List<InputResponse>?>(null,
                (List<InputResponse>? acc, PlayerInputModel element) {
          var resp = _inputResponseByPlayerInputModel(
            inputModel: element,
            cards: cards,
            corpCards: corpCards,
            number: number,
            payment: payment,
            spaceId: spaceId,
            player: player,
            partyName: partyName,
            colonyName: colonyName,
            units: units,
            aresResponse: aresResponse,
            isTargetInputModelFn: isTargetInputModelFn,
            preludeCards: preludeCards,
            amounts: amounts,
          );
          return (resp != null
              ? (acc != null
                  ? () {
                      acc.add(resp);
                      return acc;
                    }()
                  : [resp])
              : acc);
        });
        return responses != null
            ? AndOptionsResponse(responses: responses)
            : null;
      case PlayerInputType.OR:
        int index0 = 0;
        int index = 0;
        InputResponse? response = inputModel.options?.fold<InputResponse?>(null,
            (InputResponse? acc, PlayerInputModel element) {
          var resp = _inputResponseByPlayerInputModel(
            inputModel: element,
            cards: cards,
            corpCards: corpCards,
            number: number,
            payment: payment,
            spaceId: spaceId,
            player: player,
            partyName: partyName,
            colonyName: colonyName,
            units: units,
            aresResponse: aresResponse,
            isTargetInputModelFn: isTargetInputModelFn,
            preludeCards: preludeCards,
            amounts: amounts,
          );

          if (resp != null) index = index0;
          index0++;
          return resp != null ? resp : acc;
        });
        return response != null
            ? OrOptionsResponse(index: index, response: response)
            : null;
      case PlayerInputType.AND:
        List<InputResponse>? responses = inputModel.options
            ?.fold<List<InputResponse>?>(null,
                (List<InputResponse>? acc, PlayerInputModel element) {
          var resp = _inputResponseByPlayerInputModel(
            inputModel: element,
            cards: cards,
            corpCards: corpCards,
            number: number,
            payment: payment,
            spaceId: spaceId,
            player: player,
            partyName: partyName,
            colonyName: colonyName,
            units: units,
            aresResponse: aresResponse,
            isTargetInputModelFn: isTargetInputModelFn,
            preludeCards: preludeCards,
            amounts: amounts,
          );
          return (resp != null
              ? (acc != null
                  ? () {
                      acc.add(resp);
                      return acc;
                    }()
                  : [resp])
              : acc);
        });
        return responses != null
            ? AndOptionsResponse(responses: responses)
            : null;
      case PlayerInputType.CARD:
        return cards != null && isTargetInputModelFn(inputModel)
            ? SelectCardResponse(
                cards: (inputModel.title
                                ?.toString()
                                .contains("Select corporation") ??
                            false) &&
                        corpCards != null
                    ? corpCards
                    : (inputModel.title?.toString().contains("Prelude cards") ??
                                false) &&
                            preludeCards != null
                        ? preludeCards
                        : cards,
              )
            : null;
      case PlayerInputType.PROJECT_CARD:
        return cards != null &&
                payment != null &&
                isTargetInputModelFn(inputModel)
            ? SelectProjectCardToPlayResponse(
                card: cards.first, payment: payment)
            : null;
      case PlayerInputType.SPACE:
        return spaceId != null && isTargetInputModelFn(inputModel)
            ? SelectSpaceResponse(spaceId: spaceId)
            : null;
      case PlayerInputType.PLAYER:
        return player != null && isTargetInputModelFn(inputModel)
            ? SelectPlayerResponse(player: player)
            : null;
      case PlayerInputType.PARTY:
        return partyName != null && isTargetInputModelFn(inputModel)
            ? SelectPartyResponse(partyName: partyName)
            : null;
      case PlayerInputType.DELEGATE:
        return player != null && isTargetInputModelFn(inputModel)
            ? SelectDelegateResponse(player: player)
            : null;
      case PlayerInputType.AMOUNT:
        final amount = amounts?[inputModel.title.toString()];
        return isTargetInputModelFn(inputModel) && amount != null
            ? SelectAmountResponse(amount: amount)
            : null;
      case PlayerInputType.COLONY:
        return colonyName != null && isTargetInputModelFn(inputModel)
            ? SelectColonyResponse(colonyName: colonyName)
            : null;
      case PlayerInputType.PAYMENT:
        return payment != null && isTargetInputModelFn(inputModel)
            ? SelectPaymentResponse(payment: payment)
            : null;
      case PlayerInputType.PRODUCTION_TO_LOSE:
        return units != null && isTargetInputModelFn(inputModel)
            ? SelectProductionToLoseResponse(units: units)
            : null;
      case PlayerInputType.ARES_GLOBAL_PARAMETERS:
        return aresResponse != null && isTargetInputModelFn(inputModel)
            ? ShiftAresGlobalParametersResponse(response: aresResponse)
            : null;
      default:
        throw Exception('Unknown response type: ${inputModel.type}');
    }
  }

  static bool Function(PlayerInputModel) _getCheckModelFn(
    PlayerInputModel inputModel,
    PlayerInputType type,
    bool selectBlueCardAction,
    String? title,
  ) =>
      (PlayerInputModel model) =>
          model.type == type &&
          (model.selectBlueCardAction ?? false) == selectBlueCardAction &&
          (title == null
              ? true
              : model.title == null
                  ? false
                  : model.title!.toString().contains(title));

/** MA block */
  List<MilestoneName>? getAvailableMilestones() {
    final inputModel = _findInputModelByInputType(
      this,
      PlayerInputType.OR,
      false,
      "Claim a milestone",
    );
    return (inputModel == null || inputModel.options == null)
        ? null
        : inputModel.options!
            .map((e) => MilestoneName.fromString(e.title!.message))
            .cast<MilestoneName>()
            .toList();
  }

  List<AwardName>? getAvailableAwards() {
    final inputModel = _findInputModelByInputType(
      this,
      PlayerInputType.OR,
      false,
      'Fund an award',
    );
    return (inputModel == null || inputModel.options == null)
        ? null
        : inputModel.options!
            .map((e) => AwardName.fromString(e.title!.message))
            .cast<AwardName>()
            .toList();
  }

  List<PartyName>? getAvailableParties() {
    final inputModel = _findInputModelByInputType(
      this,
      PlayerInputType.PARTY,
      false,
      null,
    );
    return inputModel?.parties;
  }

  int? getDelegateCost() {
    final inputModel = _findInputModelByInputType(
      this,
      PlayerInputType.PARTY,
      false,
      null,
    );
    final title = inputModel?.title?.toString() ?? "";
    return title.contains("M€")
        ? int.parse(title.replaceAll(new RegExp(r'[^0-9]'), ''))
        : null;
  }

  bool isPolicyActionAvailable(PartyName party) =>
      _findInputModelByInputType(this, PlayerInputType.OPTION, false,
          "(Turmoil ${party.toString()})") !=
      null;
  InputResponse? getInputResponsePartyAction(PartyName party) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn: _getCheckModelFn(this, PlayerInputType.OPTION,
            false, "(Turmoil ${party.toString()})"),
      );
  bool isWorldGovernmentActionAvailable() =>
      _findInputModelByInputType(this, PlayerInputType.OR, false,
          "Select action for World Government Terraforming") !=
      null;

  InputResponse? getInputResponseIncreaseOxigen() =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn: _getCheckModelFn(
            this, PlayerInputType.OPTION, false, "Increase oxygen"),
      );

  InputResponse? getInputResponseIncreaseTemperature() =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn: _getCheckModelFn(
            this, PlayerInputType.OPTION, false, "Increase temperature"),
      );

  InputResponse? getInputResponseIncreaseVenus() =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn: _getCheckModelFn(
            this, PlayerInputType.OPTION, false, "Increase Venus scale"),
      );

  InputResponse? getInputResponseSelectedParty(PartyName party) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        partyName: party,
        isTargetInputModelFn:
            _getCheckModelFn(this, PlayerInputType.PARTY, false, null),
      );

  InputResponse? getInputResponseSelectedMA(String ma) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn:
            _getCheckModelFn(this, PlayerInputType.OPTION, false, ma),
      );

/** end MA block */

/** ProjectCards block */
  PlayerInputModel? getInputModelProjectCardsToPlay() =>
      _findInputModelByInputType(
          this, PlayerInputType.PROJECT_CARD, false, "Play project card");

  InputResponse? getInputResponseSelectedProjectCard(
          CardName card, Payment payment) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        cards: [card],
        payment: payment,
        isTargetInputModelFn: _getCheckModelFn(
            this, PlayerInputType.PROJECT_CARD, false, "Play project card"),
      );

/** end ProjectCards block */
/** Amounts block */
  PlayerInputModel? getInputModelAmounts() {
    final inputModel =
        _findInputModelByInputType(this, PlayerInputType.AND, false, null);
    return inputModel == null ||
            ((inputModel.options
                    ?.any((e) => e.type != PlayerInputType.AMOUNT) ??
                true))
        ? null
        : inputModel;
  }

  InputResponse? getInputResponseAmounts(Map<String, int> amounts) {
    final titles = amounts.keys.toList();
    var isTargetModel = (PlayerInputModel inputModel) {
      final int tileIndex = titles.indexWhere((title) =>
          _getCheckModelFn(this, PlayerInputType.AMOUNT, false, title)
              .call(inputModel));
      if (tileIndex != -1) {
        titles.removeAt(tileIndex);
        return true;
      } else {
        return false;
      }
    };
    return _inputResponseByPlayerInputModel(
      inputModel: this,
      isTargetInputModelFn: isTargetModel,
      amounts: amounts,
    );
  }

/** end Amounts block */
/** Options block */
  PlayerInputModel? getInputModelOptions() {
    final inputModel = _findInputModelByInputType(
            this, PlayerInputType.OR, false, null) ??
        _findInputModelByInputType(this, PlayerInputType.PLAYER, false, null);
    return inputModel == null ||
            ((inputModel.options
                        ?.any((e) => e.type != PlayerInputType.OPTION) ??
                    true) &&
                inputModel.type != PlayerInputType.PLAYER) ||
            getAvailableMilestones() != null ||
            getAvailableAwards() != null
        ? null
        : inputModel;
  }

  List<PlayerInputModel>? getOptionsList() => (this.options ??
          this
              .players
              ?.map((e) => PlayerInputModel(
                    type: PlayerInputType.OPTION,
                    title: Message(message: e.toString()),
                    buttonLabel: "Select",
                    selectBlueCardAction: false,
                    showReset: false,
                  ))
              .toList())
      ?.where((option) =>
          option.title.toString() != "Pass for this generation" &&
          option.title.toString() != "End Turn")
      .toList();

  InputResponse? getInputResponseSelectedOptions(String title) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn: (PlayerInputModel inputModel) =>
            _getCheckModelFn(this, PlayerInputType.OPTION, false, title)
                .call(inputModel) ||
            _getCheckModelFn(this, PlayerInputType.PLAYER, false, null)
                .call(inputModel),
        player: PlayerColor.fromString(title),
      );

/** end Options block */
/** Initial Game block */

  List<CardModel>? getAvailableInitialCards() => _findInputModelByInputType(
          this, PlayerInputType.CARD, false, "Select initial cards to buy")
      ?.cards;

  List<CardModel>? getAvailableInitialCorpCards() => _findInputModelByInputType(
          this, PlayerInputType.CARD, false, "Select corporation")
      ?.cards;

  List<CardModel>? availableInitialPreludeCards() => _findInputModelByInputType(
          this, PlayerInputType.CARD, false, "Prelude cards")
      ?.cards;

  InputResponse? getInputResponseInitialChoice(
    List<CardModel> corpCards,
    List<CardModel> projectCards,
    List<CardModel>? preludeCards,
  ) {
    var titleForSearch = [
      "Select corporation",
      "Select initial cards to buy",
      "Prelude cards"
    ];
    var isTargetModel = (PlayerInputModel inputModel) {
      final int tileIndex = titleForSearch.indexWhere((element) =>
          _getCheckModelFn(this, PlayerInputType.CARD, false, element)
              .call(inputModel));
      if (tileIndex != -1) {
        titleForSearch.removeAt(tileIndex);
        return true;
      } else {
        return false;
      }
    };
    return _inputResponseByPlayerInputModel(
      inputModel: this,
      cards: projectCards.map((e) => e.name).toList(),
      corpCards: corpCards.map((e) => e.name).toList(),
      preludeCards: preludeCards?.map((e) => e.name).toList(),
      isTargetInputModelFn: isTargetModel,
    );
  }
/** end Initial Game block */

/*StandartProjects block */
  PlayerInputModel? getInputModelStandartProjects() =>
      _findInputModelByInputType(
          this, PlayerInputType.CARD, false, "Standard projects");

  InputResponse? getInputResponseSelectedStandartProject(CardName card) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        cards: [card],
        isTargetInputModelFn: _getCheckModelFn(
            this, PlayerInputType.CARD, false, "Standard projects"),
      );

  PlayerInputModel? getInputModelSellPatents() => _findInputModelByInputType(
      this, PlayerInputType.CARD, false, "Sell patents");

  InputResponse? getInputResponseSelectedSellPatents(List<CardName> cards) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        cards: cards,
        isTargetInputModelFn:
            _getCheckModelFn(this, PlayerInputType.CARD, false, "Sell patents"),
      );

/*end StandartProjects block */

  PlayerInputModel? inputModelCardsToSelect() {
    final regularCards =
        _findInputModelByInputType(this, PlayerInputType.CARD, false, "Select");
    final preludeMergerCorporationCards = _findInputModelByInputType(
        this, PlayerInputType.CARD, false, "Choose corporation card to play");
    return regularCards ?? preludeMergerCorporationCards;
  }

  InputResponse? getInputResponseSelectedCards(List<CardName> cards) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        cards: cards,
        isTargetInputModelFn: (PlayerInputModel inputModel) =>
            _getCheckModelFn(this, PlayerInputType.CARD, false, "Select")
                .call(inputModel) ||
            _getCheckModelFn(this, PlayerInputType.CARD, false,
                    "Choose corporation card to play")
                .call(inputModel),
      );

  PlayerInputModel? getInputModelActions() =>
      _findInputModelByInputType(this, PlayerInputType.CARD, true, null);

  InputResponse? getInputResponseActionCards(CardName card) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        cards: [card],
        isTargetInputModelFn:
            _getCheckModelFn(this, PlayerInputType.CARD, true, null),
      );

  InputResponse? getInputResponseHeatIncrease() =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn: _getCheckModelFn(
            this, PlayerInputType.OPTION, false, "heat into temperature"),
      );

  InputResponse? getInputResponsePass() => _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn: _getCheckModelFn(
            this, PlayerInputType.OPTION, false, "Pass for this generation"),
      );

  String? getOnConfirmPassButtonText() => _findInputModelByInputType(
          this, PlayerInputType.OPTION, false, "Pass for this generation")
      ?.buttonLabel;

  InputResponse? getInputResponseSkip() => _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn:
            _getCheckModelFn(this, PlayerInputType.OPTION, false, "End Turn"),
      );

  String? getOnConfirmSkipButtonText() => _findInputModelByInputType(
          this, PlayerInputType.OPTION, false, "End Turn")
      ?.buttonLabel;

  List<SpaceId>? getAvailableSpaces(String? title) =>
      _findInputModelByInputType(this, PlayerInputType.SPACE, false, title)
          ?.spaces;

  InputResponse? getInputResponseSpace(SpaceId spaceId, String? title) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn:
            _getCheckModelFn(this, PlayerInputType.SPACE, false, title),
        spaceId: spaceId,
      );

  InputResponse? getInputResponsePay(Payment payment) =>
      _inputResponseByPlayerInputModel(
        inputModel: this,
        isTargetInputModelFn:
            _getCheckModelFn(this, PlayerInputType.PAYMENT, false, null),
        payment: payment,
      );

  bool isPaymentAvailable() =>
      _findInputModelByInputType(this, PlayerInputType.PAYMENT, false, null) !=
      null;
}
