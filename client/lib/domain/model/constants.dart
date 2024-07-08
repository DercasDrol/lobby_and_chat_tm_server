// Base constants
const CARD_COST = 3;
const MILESTONE_COST = 8;
const MAX_MILESTONES = 3;
const AWARD_COSTS = [8, 14, 20];
const MAX_AWARDS = 3;
const DEFAULT_STEEL_VALUE = 2;
const DEFAULT_TITANIUM_VALUE = 3;
const FLOATERS_VALUE = 3;
const MICROBES_VALUE = 2;
const OCEAN_BONUS = 2;

// Global parameters
const HEAT_FOR_TEMPERATURE = 8;
const MAX_OCEAN_TILES = 9;
const MAX_TEMPERATURE = 8;
const MAX_OXYGEN_LEVEL = 14;
const MIN_TEMPERATURE = -30;
const MIN_OXYGEN_LEVEL = 0;
const MIN_VENUS_SCALE = 0;
const MAX_VENUS_SCALE = 30;

const OXYGEN_LEVEL_FOR_TEMPERATURE_BONUS = 8;
const TEMPERATURE_FOR_OCEAN_BONUS = 0;
const VENUS_LEVEL_FOR_CARD_BONUS = 8;
const VENUS_LEVEL_FOR_TR_BONUS = 16;
const ALT_VENUS_MINIMUM_BONUS = 16;
const TEMPERATURE_BONUS_FOR_HEAT_1 = -24;
const TEMPERATURE_BONUS_FOR_HEAT_2 = -20;

// Colonies
const MAX_COLONY_TRACK_POSITION = 6;
const MAX_COLONIES_PER_TILE = 3;
const MAX_FLEET_SIZE = 4;
const MC_TRADE_COST = 9;
const ENERGY_TRADE_COST = 3;
const TITANIUM_TRADE_COST = 3;

// Turmoil
const DELEGATES_PER_PLAYER = 7;
const DELEGATES_FOR_NEUTRAL_PLAYER = 14;
const REDS_RULING_POLICY_COST = 3;
const POLITICAL_AGENDAS_MAX_ACTION_USES = 3;

// Promo

const GRAPHENE_VALUE = 4;

// Map specific
const HELLAS_BONUS_OCEAN_COST = 6;
const VASTITAS_BOREALIS_BONUS_TEMPERATURE_COST = 3;

// Moon
const MAXIMUM_HABITAT_RATE = 8;
const MAXIMUM_MINING_RATE = 8;
const MAXIMUM_LOGISTICS_RATE = 8;

// Pathfinders
const SEED_VALUE = 5;
const DATA_VALUE = 3;

// Escape Velocity
const DEFAULT_ESCAPE_VELOCITY_THRESHOLD = 30;
const DEFAULT_ESCAPE_VELOCITY_BONUS_SECONDS = 2;
const DEFAULT_ESCAPE_VELOCITY_PERIOD = 2;
const DEFAULT_ESCAPE_VELOCITY_PENALTY = 1;
const BONUS_SECONDS_PER_ACTION = 5;

// Leaders/CEOs
const ASIMOV_AWARD_BONUS = 2;

enum Language {
  EN,
  DE,
  FR,
  RU,
  CN,
  PL,
  ES,
  BR,
  IT,
  KO,
  NL,
  HU,
  JP,
  BG;

  static const _TO_STRING_MAP = {
    EN: 'English',
    DE: 'Deutsch',
    FR: 'Français',
    RU: 'Русский',
    CN: '华语',
    PL: 'Polski',
    ES: 'Español',
    BR: 'Português Brasileiro',
    IT: 'Italiano',
    KO: '한국어',
    NL: 'Nederlands',
    HU: 'Magyar',
    JP: '日本語',
    BG: 'Български',
  };
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
}

const APP_NAME = 'Terraforming Mars';
const DISCORD_INVITE = 'https://discord.gg/afeyggbN6Y';
const PRELUDE_CARDS_DEALT_PER_PLAYER = 4;
const SELECTED_GAME_CLIENT = 'selected_game_client';
//routes
const LOBBY_ROUTE = '/lobby';
const GAME_CLIENT_ROUTE = '/game_client';
const NEW_GAME_CLIENT_ROUTE = '/new_game_client';
const CARDS_ROUTE = '/cards';
const MAIN_MENU_ROUTE = '/';
const AUTH_ROUTE = '/auth';

//description urls
//--------------------------
//expansions
const PROMO_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#promo-cards';
const ARES_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Ares';
const COMMUNITY_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#community';
const MOON_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/The-Moon';
const PATHFINDERS_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Pathfinders';
const CEO_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/CEOs';
const STARWARS_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/StarWars';
const UNDERWORLD_EXPANSION_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Underworld';

//boards
const THARSIS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#tharsis';
const HELLAS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#hellas';
const ELYSIUM_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#elysium';
const UTOPIA_PLANITIA_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#utopia-planitia';
const VASTITAS_BOREALIS_NOVUS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#vastitas-borealis-novus';
const ARABIA_TERRA_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#arabia-terra';
const VASTITAS_BOREALIS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#vastitas-borealis';
const AMAZONIS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#amazonis-planatia';
const TERRA_CIMMERIA_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Maps#terra-cimmeria';

//Options
const MOON_STANDART_PROJECTS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#moon-standard-project-variant';
const VENUS_ALTERNATIVE_BOARD_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Alternative-Venus-Board';
const MANDATORY_VENUS_TERRAFORMING_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#venus-terraforming';
const TURMOIL_AGENDAS_DESCRIPTION_URL =
    'https://www.notion.so/Political-Agendas-8c6b0b018a884692be29b3ef44b340a9';
const WORLD_GOVEREMENT_TERRAFORMING_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#solar-phase';
const SOLO_63_TR_MODE_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#tr-solo-mode';
const ALLOW_UNDO_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#allow-undo';
const ESCAPE_VELOCITY_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Escape-Velocity';
const MERGER_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#Merger';
const RANDOMIZE_BOARDS_TILES_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#randomize-board-tiles';
const SET_PREDEFINED_GAME_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#set-predefined-game';

//filters
const REMOVE_NEGATIVE_GLOBAL_EVENTS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#remove-negative-global-events';

// multiplayer options
const INITIAL_DRAFT_VARIANTS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#initial-draft';
const RANDOM_MILESTOUNES_AWARDS_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#random-milestones-and-awards';
const SHOW_REALTIME_VP_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#show-real-time-vp';
const FAST_MODE_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#fast-mode';

//player options
const TR_BOOST_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#tr-boost';
const BEGGINER_DESCRIPTION_URL =
    'https://github.com/terraforming-mars/terraforming-mars/wiki/Variants#beginner-corporation';

const DISCORD_AVATAR_URL = 'https://cdn.discordapp.com/avatars/';

const DISCORD_USER_URL = 'https://discord.com/users/';
