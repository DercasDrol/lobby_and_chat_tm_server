enum GlobalEventName {
  GLOBAL_DUST_STORM,
  SPONSORED_PROJECTS,
  ASTEROID_MINING,
  GENEROUS_FUNDING,
  SUCCESSFUL_ORGANISMS,
  ECO_SABOTAGE,
  PRODUCTIVITY,
  SNOW_COVER,
  DIVERSITY,
  PANDEMIC,
  WAR_ON_EARTH,
  IMPROVED_ENERGY_TEMPLATES,
  INTERPLANETARY_TRADE,
  CELEBRITY_LEADERS,
  SPINOFF_PRODUCTS,
  ELECTION,
  AQUIFER_RELEASED_BY_PUBLIC_COUNCIL,
  PARADIGM_BREAKDOWN,
  HOMEWORLD_SUPPORT,
  RIOTS,
  VOLCANIC_ERUPTIONS,
  MUD_SLIDES,
  MINERS_ON_STRIKE,
  SABOTAGE,
  REVOLUTION,
  DRY_DESERTS,
  SCIENTIFIC_COMMUNITY,
  CORROSIVE_RAIN,
  JOVIAN_TAX_RIGHTS,
  RED_INFLUENCE,
  SOLARNET_SHUTDOWN,
  STRONG_SOCIETY,
  SOLAR_FLARE,
  VENUS_INFRASTRUCTURE,
  CLOUD_SOCIETIES,
  MICROGRAVITY_HEALTH_PROBLEMS,

  // Community
  LEADERSHIP_SUMMIT,

  // Pathfinders
  BALANCED_DEVELOPMENT,
  CONSTANT_STRUGGLE,
  TIRED_EARTH,
  MAGNETIC_FIELD_STIMULATION_DELAYS,
  COMMUNICATION_BOOM,
  SPACE_RACE_TO_MARS,

  // Underworld
  LAGGING_REGULATION,
  FAIR_TRADE_COMPLAINT,
  MIGRATION_UNDERGROUND,
  SEISMIC_PREDICTIONS,
  MEDIA_STIR;

  static const _TO_STRING_MAP = {
    GLOBAL_DUST_STORM: 'Global Dust Storm',
    SPONSORED_PROJECTS: 'Sponsored Projects',
    ASTEROID_MINING: 'Asteroid Mining',
    GENEROUS_FUNDING: 'Generous Funding',
    SUCCESSFUL_ORGANISMS: 'Successful Organisms',
    ECO_SABOTAGE: 'Eco Sabotage',
    PRODUCTIVITY: 'Productivity',
    SNOW_COVER: 'Snow Cover',
    DIVERSITY: 'Diversity',
    PANDEMIC: 'Pandemic',
    WAR_ON_EARTH: 'War on Earth',
    IMPROVED_ENERGY_TEMPLATES: 'Improved Energy Templates',
    INTERPLANETARY_TRADE: 'Interplanetary Trade',
    CELEBRITY_LEADERS: 'Celebrity Leaders',
    SPINOFF_PRODUCTS: 'Spin-Off Products',
    ELECTION: 'Election',
    AQUIFER_RELEASED_BY_PUBLIC_COUNCIL: 'Aquifer Released by Public Council',
    PARADIGM_BREAKDOWN: 'Paradigm Breakdown',
    HOMEWORLD_SUPPORT: 'Homeworld Support',
    RIOTS: 'Riots',
    VOLCANIC_ERUPTIONS: 'Volcanic Eruptions',
    MUD_SLIDES: 'Mud Slides',
    MINERS_ON_STRIKE: 'Miners On Strike',
    SABOTAGE: 'Sabotage',
    REVOLUTION: 'Revolution',
    DRY_DESERTS: 'Dry Deserts',
    SCIENTIFIC_COMMUNITY: 'Scientific Community',
    CORROSIVE_RAIN: 'Corrosive Rain',
    JOVIAN_TAX_RIGHTS: 'Jovian Tax Rights',
    RED_INFLUENCE: 'Red Influence',
    SOLARNET_SHUTDOWN: 'Solarnet Shutdown',
    STRONG_SOCIETY: 'Strong Society',
    SOLAR_FLARE: 'Solar Flare',
    VENUS_INFRASTRUCTURE: 'Venus Infrastructure',
    CLOUD_SOCIETIES: 'Cloud Societies',
    MICROGRAVITY_HEALTH_PROBLEMS: 'Microgravity Health Problems',

    // Community
    LEADERSHIP_SUMMIT: 'Leadership Summit',

    // Pathfinders
    BALANCED_DEVELOPMENT: 'Balanced Development',
    CONSTANT_STRUGGLE: 'Constant Struggle',
    TIRED_EARTH: 'Tired Earth',
    MAGNETIC_FIELD_STIMULATION_DELAYS: 'Magnetic Field Stimulation Delays',
    COMMUNICATION_BOOM: 'Communication Boom',
    SPACE_RACE_TO_MARS: 'Space Race to Mars',

    // Underworld
    LAGGING_REGULATION: 'Lagging Regulation',
    FAIR_TRADE_COMPLAINT: 'Fair Trade Complaint',
    MIGRATION_UNDERGROUND: 'Migration Underground',
    SEISMIC_PREDICTIONS: 'Seismic Predictions',
    MEDIA_STIR: 'Media Stir',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));

  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();

  static fromString(String? value) => _TO_ENUM_MAP[value];
}
