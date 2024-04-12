const AUTH_CHAT_LOBBY_HOST = String.fromEnvironment('AUTH_CHAT_LOBBY_WS_HOST',
    defaultValue: 'ws://localhost');
const LOGGING_LEVEL =
    String.fromEnvironment('CLIENT_LOGGING_LEVEL', defaultValue: 'all');
const LOGGING_ENABLED =
    String.fromEnvironment('CLIENT_LOGGING_ENABLED', defaultValue: 'true') ==
        'true';
const CHAT_PORT = String.fromEnvironment('CHAT_PORT', defaultValue: '4002');
const LOBBY_PORT = String.fromEnvironment('LOBBY_PORT', defaultValue: '4001');
const AUTH_PORT = String.fromEnvironment('AUTH_PORT', defaultValue: '4000');
const GAME_SERVER_HOST = String.fromEnvironment('GAME_SERVER_HOST',
    defaultValue: 'https://terraforming-mars.herokuapp.com');
