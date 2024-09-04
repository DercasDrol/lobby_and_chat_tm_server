import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/i_ma_and_party_model.dart';
import 'package:mars_flutter/domain/model/i_ma_and_party_score.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';
import 'package:mars_flutter/domain/model/turmoil/globalEvents/GlobalEventName.dart';

class TurmoilModel {
  final PartyName? dominant;
  final PartyName? ruling;
  final PlayerColor? chairman;
  final List<PartyModel> parties;
  final List<PlayerColor> lobby;
  final List<DelegatesModel> reserve;
  final GlobalEventName? distant;
  final GlobalEventName? coming;
  final GlobalEventName? current;
  final PoliticalAgendasModel? politicalAgendas;
  final List<PolicyUser> policyActionUsers;

  TurmoilModel({
    required this.dominant,
    required this.ruling,
    required this.chairman,
    required this.parties,
    required this.lobby,
    required this.reserve,
    required this.distant,
    required this.coming,
    required this.current,
    required this.politicalAgendas,
    required this.policyActionUsers,
  });

  static TurmoilModel fromJson(Map<String, dynamic> json) {
    final PartyName? dominant = json['dominant'] == null
        ? null
        : PartyName.fromString(json['dominant']);
    final PartyName? ruling =
        json['ruling'] == null ? null : PartyName.fromString(json['ruling']);
    final PlayerColor? chairman = json['chairman'] == null
        ? null
        : PlayerColor.fromString(json['chairman']);
    final List<PartyModel> parties = json['parties']
        .map((e) => PartyModel.fromJson(e))
        .cast<PartyModel>()
        .toList();
    final List<PlayerColor> lobby = json['lobby']
        .map((e) => PlayerColor.fromString(e as String))
        .cast<PlayerColor>()
        .toList();
    final List<DelegatesModel> reserve = (json['reserve'] as List<dynamic>)
        .map((e) => DelegatesModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final GlobalEventName? distant = json['distant'] == null
        ? null
        : GlobalEventName.fromString(json['distant']);
    final GlobalEventName? coming = json['coming'] == null
        ? null
        : GlobalEventName.fromString(json['coming']);
    final GlobalEventName? current = json['current'] == null
        ? null
        : GlobalEventName.fromString(json['current']);
    final PoliticalAgendasModel? politicalAgendas =
        json['politicalAgendas'] == null
            ? null
            : PoliticalAgendasModel.fromJson(
                json['politicalAgendas'] as Map<String, dynamic>);
    final List<PolicyUser> policyActionUsers =
        (json['policyActionUsers'] as List<dynamic>)
            .map((e) => PolicyUser.fromJson(e as Map<String, dynamic>))
            .toList();

    return TurmoilModel(
      dominant: dominant,
      ruling: ruling,
      chairman: chairman,
      parties: parties,
      lobby: lobby,
      reserve: reserve,
      distant: distant,
      coming: coming,
      current: current,
      politicalAgendas: politicalAgendas,
      policyActionUsers: policyActionUsers,
    );
  }
}

class PolicyUser {
  final PlayerColor color;
  final bool turmoilPolicyActionUsed;
  final int politicalAgendasActionUsedCount;

  PolicyUser({
    required this.color,
    required this.turmoilPolicyActionUsed,
    required this.politicalAgendasActionUsedCount,
  });
  static PolicyUser fromJson(Map<String, dynamic> json) {
    return PolicyUser(
      color: PlayerColor.fromString(json['color'] as String) ??
          PlayerColor.NEUTRAL,
      turmoilPolicyActionUsed: json['turmoilPolicyActionUsed'] as bool,
      politicalAgendasActionUsedCount:
          json['politicalAgendasActionUsedCount'] as int,
    );
  }
}

class PartyModel extends IMaAndPartyModel {
  final PartyName name;
  final PlayerColor? partyLeader;
  final List<DelegatesModel> delegates;

  PartyModel({
    required this.name,
    required this.partyLeader,
    required this.delegates,
  }) : super(name: name);

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return PartyModel(
      name: PartyName.fromString(json['name'] as String),
      partyLeader: json['partyLeader'] == null
          ? null
          : PlayerColor.fromString(json['partyLeader'] as String),
      delegates: json['delegates'] == []
          ? []
          : (json['delegates'] as List<dynamic>)
              .map((e) => DelegatesModel(
                    color: PlayerColor.fromString(e['color'] as String) ??
                        PlayerColor.NEUTRAL,
                    number: e['number'] as int,
                  ))
              .toList(),
    );
  }
}

class DelegatesModel implements IMaAndPartyScore {
  final PlayerColor color;
  final int number;

  DelegatesModel({required this.color, required this.number});

  static DelegatesModel fromJson(Map<String, dynamic> json) {
    return DelegatesModel(
      color: PlayerColor.fromString(json['color'] as String) ??
          PlayerColor.NEUTRAL,
      number: json['number'] as int,
    );
  }
}

class GlobalEventModel {
  final GlobalEventName name;
  final String description;
  final PartyName revealed;
  final PartyName current;

  GlobalEventModel({
    required this.name,
    required this.description,
    required this.revealed,
    required this.current,
  });

  static GlobalEventModel fromJson(Map<String, dynamic> json) {
    return GlobalEventModel(
      name: GlobalEventName.fromString(json['name'] as String),
      description: json['description'] as String,
      revealed: PartyName.fromString(json['revealed'] as String),
      current: PartyName.fromString(json['current'] as String),
    );
  }
}

class PoliticalAgendasModel {
  final Agenda marsFirst;
  final Agenda scientists;
  final Agenda unity;
  final Agenda greens;
  final Agenda reds;
  final Agenda kelvinists;

  PoliticalAgendasModel({
    required this.marsFirst,
    required this.scientists,
    required this.unity,
    required this.greens,
    required this.reds,
    required this.kelvinists,
  });

  Agenda getAgenda(PartyName party) {
    switch (party) {
      case PartyName.MARS:
        return marsFirst;
      case PartyName.SCIENTISTS:
        return scientists;
      case PartyName.UNITY:
        return unity;
      case PartyName.GREENS:
        return greens;
      case PartyName.REDS:
        return reds;
      case PartyName.KELVINISTS:
        return kelvinists;
      default:
        throw Exception('Unknown party $party');
    }
  }

  static PoliticalAgendasModel fromJson(Map<String, dynamic> json) {
    return PoliticalAgendasModel(
      marsFirst: Agenda.fromJson(json['marsFirst'] as Map<String, dynamic>),
      scientists: Agenda.fromJson(json['scientists'] as Map<String, dynamic>),
      unity: Agenda.fromJson(json['unity'] as Map<String, dynamic>),
      greens: Agenda.fromJson(json['greens'] as Map<String, dynamic>),
      reds: Agenda.fromJson(json['reds'] as Map<String, dynamic>),
      kelvinists: Agenda.fromJson(json['kelvinists'] as Map<String, dynamic>),
    );
  }
}
