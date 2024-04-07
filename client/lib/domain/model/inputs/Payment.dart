//const PAYMENT_KEYS = ['heat', 'megaCredits', 'steel', 'titanium', 'microbes', 'floaters', 'science', 'seeds', 'data'] as const;

enum PaymentKey {
  HEAT,
  MEGACREDITS,
  STEEL,
  TITANIUM,
  MICROBES,
  FLOATERS,
  LUNA_ACHIVES_SCIENCE,
  SPIRE_SCIENCE,
  SEEDS,
  AURORAI_DATA;

  static const _TO_STRING_MAP = {
    HEAT: 'heat',
    MEGACREDITS: 'megaCredits',
    STEEL: 'steel',
    TITANIUM: 'titanium',
    MICROBES: 'microbes',
    FLOATERS: 'floaters',
    LUNA_ACHIVES_SCIENCE: 'lunaArchivesScience',
    SPIRE_SCIENCE: 'spireScience',
    SEEDS: 'seeds',
    AURORAI_DATA: 'auroraiData',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}

class Payment {
  // Standard currency for paying for stuff
  final int megaCredits;
  // Helion corporation can spend heat as M€.
  final int heat;
  // Used for cards with building tags
  final int steel;
  // Used for cards with space tags
  final int titanium;
  // Psychrophiles corporation can spend its floaters for cards with plant tags.
  final int microbes;
  // Dirigibles corporation can spend its floaters for cards with Venus tags.
  final int floaters;
  // Luna Archives corporation can spend its science resources for cards with Moon tags.
  final int lunaArchivesScience;
  // Spire corporation can spend its science resources on standrad projects.
  final int spireScience;
  // Soylent Seedling Systems corporation can use its seeds to pay for cards with plant tags, or the standard greenery project.
  final int seeds;
  // Aurorai corporation can use its data to pay for standard projects.
  final int auroraiData;
  // Graphene is a Carbon Nanosystems resource that pays for city and space projects.
  final int graphene;
  // Asteroids is a Kuiper Cooperative resource that pays for aquifer and asteroid standard projects.
  final int kuiperAsteroids;

  const Payment({
    required this.megaCredits,
    required this.heat,
    required this.steel,
    required this.titanium,
    required this.microbes,
    required this.floaters,
    required this.lunaArchivesScience,
    required this.seeds,
    required this.auroraiData,
    required this.graphene,
    required this.kuiperAsteroids,
    required this.spireScience,
  });
  static const Payment EMPTY = Payment(
    megaCredits: 0,
    heat: 0,
    steel: 0,
    titanium: 0,
    microbes: 0,
    floaters: 0,
    lunaArchivesScience: 0,
    seeds: 0,
    auroraiData: 0,
    graphene: 0,
    kuiperAsteroids: 0,
    spireScience: 0,
  );

  factory Payment.fromJson({required json}) {
    return Payment(
      megaCredits: json['megaCredits'] ?? 0,
      heat: json['heat'] ?? 0,
      steel: json['steel'] ?? 0,
      titanium: json['titanium'] ?? 0,
      microbes: json['microbes'] ?? 0,
      floaters: json['floaters'] ?? 0,
      lunaArchivesScience: json['lunaArchivesScience'] ?? 0,
      seeds: json['seeds'] ?? 0,
      auroraiData: json['auroraiData'] ?? 0,
      graphene: json['graphene'] ?? 0,
      kuiperAsteroids: json['kuiperAsteroids'] ?? 0,
      spireScience: json['spireScience'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'megaCredits': megaCredits,
        'heat': heat,
        'steel': steel,
        'titanium': titanium,
        'microbes': microbes,
        'floaters': floaters,
        'lunaArchivesScience': lunaArchivesScience,
        'seeds': seeds,
        'auroraiData': auroraiData,
        'graphene': graphene,
        'kuiperAsteroids': kuiperAsteroids,
        'spireScience': spireScience,
      };
}

class Options {
  final bool steel;
  final bool titanium;
  final bool floaters;
  final bool microbes;
  final bool lunaArchivesScience;
  final bool seeds;
  final bool auroraiData;

  final bool graphene;
  final bool kuiperAsteroids;
  const Options({
    required this.steel,
    required this.titanium,
    required this.floaters,
    required this.microbes,
    required this.lunaArchivesScience,
    required this.seeds,
    required this.auroraiData,
    required this.graphene,
    required this.kuiperAsteroids,
  });
}

class PaymentInfo {
  final int targetSum;
  final int steelValue;
  final int titaniumValue;
  final Payment availablePayment;
  static const int floatersValue = 3;
  static const int microbesValue = 2;
  static const int lunaArchivesScienceValue = 1;
  static const int spireScienceValue = 2;

  static const int seedsValue = 5;
  static const int auroraiData = 1;
  static const int graphene = 4;
  PaymentInfo({
    required this.targetSum,
    required this.steelValue,
    required this.titaniumValue,
    required this.availablePayment,
  });
}
