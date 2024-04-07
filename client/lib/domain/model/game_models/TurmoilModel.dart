import 'package:mars_flutter/domain/model/Color.dart';
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
  final GlobalEventModel? distant;
  final GlobalEventModel? coming;
  final GlobalEventModel? current;
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
    return TurmoilModel(
      dominant: json['dominant'] == null
          ? null
          : PartyName.fromString(json['dominant'] as String),
      ruling: json['ruling'] == null
          ? null
          : PartyName.fromString(json['ruling'] as String),
      chairman: json['chairman'] == null
          ? null
          : PlayerColor.fromString(json['chairman'] as String),
      parties: (json['parties'] as List<dynamic>)
          .map((e) => PartyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lobby: json['lobby']
          .map((e) => PlayerColor.fromString(e as String))
          .toList(),
      reserve: (json['reserve'] as List<dynamic>)
          .map((e) => DelegatesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      distant: json['distant'] == null
          ? null
          : GlobalEventModel.fromJson(json['distant'] as Map<String, dynamic>),
      coming: json['coming'] == null
          ? null
          : GlobalEventModel.fromJson(json['coming'] as Map<String, dynamic>),
      current: json['current'] == null
          ? null
          : GlobalEventModel.fromJson(json['current'] as Map<String, dynamic>),
      politicalAgendas: json['politicalAgendas'] == null
          ? null
          : PoliticalAgendasModel.fromJson(
              json['politicalAgendas'] as Map<String, dynamic>),
      policyActionUsers: (json['policyActionUsers'] as List<dynamic>)
          .map((e) => PolicyUser.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      color: PlayerColor.fromString(json['color'] as String),
      turmoilPolicyActionUsed: json['turmoilPolicyActionUsed'] as bool,
      politicalAgendasActionUsedCount:
          json['politicalAgendasActionUsedCount'] as int,
    );
  }
}

class PartyModel {
  final PartyName name;
  final String description;
  final PlayerColor? partyLeader;
  final List<DelegatesModel> delegates;

  PartyModel({
    required this.name,
    required this.description,
    required this.partyLeader,
    required this.delegates,
  });

  static PartyModel fromJson(Map<String, dynamic> json) {
    return PartyModel(
      name: PartyName.fromString(json['name'] as String),
      description: json['description'] as String,
      partyLeader: json['partyLeader'] == null
          ? null
          : PlayerColor.fromString(json['partyLeader'] as String),
      delegates: (json['delegates'] as List<dynamic>)
          .map((e) => DelegatesModel(
                color: PlayerColor.fromString(e['color'] as String),
                number: e['number'] as int,
              ))
          .toList(),
    );
  }
}

class DelegatesModel {
  final PlayerColor color;
  final int number;

  DelegatesModel({
    required this.color,
    required this.number,
  });

  static DelegatesModel fromJson(Map<String, dynamic> json) {
    return DelegatesModel(
      color: PlayerColor.fromString(json['color'] as String),
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
