enum RequestPath {
  ADMIN,
  API_CLONEABLEGAME,
  API_GAME,
  API_GAME_HISTORY,
  API_GAME_LOGS,
  API_GAMES,
  API_METRICS,
  API_PLAYER,
  API_SPECTATOR,
  API_STATS,
  API_WAITING_FOR,
  CARDS,
  GAME,
  GAMES_OVERVIEW,
  HELP,
  LOAD,
  LOAD_GAME,
  NEW_GAME,
  PLAYER,
  PLAYER_INPUT,
  RESET,
  SPECTATOR,
  THE_END;

  static const _TO_STRING_MAP = {
    ADMIN: 'admin',
    API_CLONEABLEGAME: 'api/cloneablegame',
    API_GAME: 'api/game',
    API_GAME_HISTORY: 'api/game/history',
    API_GAME_LOGS: 'api/game/logs',
    API_GAMES: 'api/games',
    API_METRICS: 'api/metrics',
    API_PLAYER: 'api/player',
    API_SPECTATOR: 'api/spectator',
    API_STATS: 'api/stats',
    API_WAITING_FOR: 'api/waitingfor',
    CARDS: 'cards',
    GAME: 'game',
    GAMES_OVERVIEW: 'games-overview',
    HELP: 'help',
    LOAD: 'load',
    LOAD_GAME: 'load_game',
    NEW_GAME: 'new-game',
    PLAYER: 'player',
    PLAYER_INPUT: 'player/input',
    RESET: 'reset',
    SPECTATOR: 'spectator',
    THE_END: 'the-end',
  };
  static final _TO_ENUM_MAP =
      _TO_STRING_MAP.map((key, value) => MapEntry(value, key));
  @override
  String toString() => _TO_STRING_MAP[this] ?? this.toString();
  static fromString(String? value) => _TO_ENUM_MAP[value];
}
