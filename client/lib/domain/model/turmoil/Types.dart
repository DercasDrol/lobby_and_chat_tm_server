enum AgendaStyle {
  STANDARD,
  RANDOM,
  CHAIRMAN;

  static const _TO_STRING_MAP = {
    STANDARD: 'Standard',
    RANDOM: 'Random',
    CHAIRMAN: 'Chairman',
  };

  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();

  static AgendaStyle? fromString(String? value) => _TO_ENUM_MAP[value];
}

class BonusId {
  late final String? id;
  factory BonusId(string) {
    return BonusId(RegExp(r'[m,s,u,k,r,g][b][0][1,2]').hasMatch(string) &&
            string.length == 4
        ? string
        : null);
  }
  @override
  String toString() => id ?? 'undefined BonusId';
}

class PolicyId {
  late final String? id;
  factory PolicyId(string) {
    return PolicyId(RegExp(string.length == 4
                    ? r'[m,s,u,k,r,g][b][0][1,2]'
                    : r'[m,s,u,k,r,g][f][b][0][1,2]')
                .hasMatch(string) &&
            (string.length == 4 || string.length == 5)
        ? string
        : null);
  }
  @override
  String toString() => id ?? 'undefined PolicyId';
}

class Agenda {
  final BonusId bonusId;
  final PolicyId policyId;
  Agenda({required this.bonusId, required this.policyId});

  static Agenda fromJson(Map<String, dynamic> json) {
    return Agenda(
      bonusId: BonusId(json['bonusId'] as String),
      policyId: PolicyId(json['policyId'] as String),
    );
  }
}
