/**export enum ColonyName {
    CALLISTO = 'Callisto',
    CERES = 'Ceres',
    ENCELADUS = 'Enceladus',
    EUROPA = 'Europa',
    GANYMEDE = 'Ganymede',
    IO = 'Io',
    LUNA = 'Luna',
    MIRANDA = 'Miranda',
    PLUTO = 'Pluto',
    TITAN = 'Titan',
    TRITON = 'Triton',

    // Community
    // If you add a community colony, update
    // GameSetup.includesCommunityColonies
    // ColonyDescription
    IAPETUS = 'Iapetus',
    MERCURY = 'Mercury',
    HYGIEA = 'Hygiea',
    TITANIA = 'Titania',
    VENUS = 'Venus',
    LEAVITT = 'Leavitt',
    PALLAS = 'Pallas',

    // Pathfinders
    LEAVITT_II = 'Leavitt II',
    IAPETUS_II = 'Iapetus II',

} */

enum ColonyName {
  CALLISTO,
  CERES,
  ENCELADUS,
  EUROPA,
  GANYMEDE,
  IO,
  LUNA,
  MIRANDA,
  PLUTO,
  TITAN,
  TRITON,

  // Community
  // If you add a community colony, update
  // GameSetup.includesCommunityColonies
  // ColonyDescription
  IAPETUS,
  MERCURY,
  HYGIEA,
  TITANIA,
  VENUS,
  LEAVITT,
  PALLAS,

  // Pathfinders
  LEAVITT_II,
  IAPETUS_II;

  static const _TO_STRING_MAP = {
    CALLISTO: 'Callisto',
    CERES: 'Ceres',
    ENCELADUS: 'Enceladus',
    EUROPA: 'Europa',
    GANYMEDE: 'Ganymede',
    IO: 'Io',
    LUNA: 'Luna',
    MIRANDA: 'Miranda',
    PLUTO: 'Pluto',
    TITAN: 'Titan',
    TRITON: 'Triton',
    IAPETUS: 'Iapetus',
    MERCURY: 'Mercury',
    HYGIEA: 'Hygiea',
    TITANIA: 'Titania',
    VENUS: 'Venus',
    LEAVITT: 'Leavitt',
    PALLAS: 'Pallas',
    LEAVITT_II: 'Leavitt II',
    IAPETUS_II: 'Iapetus II',
  };
  static const _TO_DESCRIPTION_MAP = {
    CALLISTO: 'Energy',
    CERES: 'Steel',
    ENCELADUS: 'Microbes',
    EUROPA: 'Production',
    GANYMEDE: 'Plants',
    IO: 'Heat',
    LUNA: 'MegaCredits',
    MIRANDA: 'Animals',
    PLUTO: 'Cards',
    TITAN: 'Floaters',
    TRITON: 'Titanium',
    IAPETUS: 'TR',
    MERCURY: 'Production',
    HYGIEA: 'Attack',
    TITANIA: 'VP',
    VENUS: 'Venus',
    LEAVITT: 'Science',
    PALLAS: 'Politics',
    LEAVITT_II: 'Science & Clone Tags',
    IAPETUS_II: 'Data',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  String toDescription() => _TO_DESCRIPTION_MAP[this] ?? this.toString();
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
  static const Set<ColonyName> OFFICIAL_COLONY_NAMES = {
    CALLISTO,
    CERES,
    ENCELADUS,
    EUROPA,
    GANYMEDE,
    IO,
    LUNA,
    MIRANDA,
    PLUTO,
    TITAN,
    TRITON,
  };
  static const Set<ColonyName> COMMUNITY_COLONY_NAMES = {
    IAPETUS,
    MERCURY,
    HYGIEA,
    TITANIA,
    VENUS,
    LEAVITT,
    PALLAS,
  };
  static const Set<ColonyName> PATHFINDER_COLONY_NAMES = {
    LEAVITT_II,
    IAPETUS_II,
  };
}
