const AUTH_CHAT_LOBBY_HOST = String.fromEnvironment('AUTH_CHAT_LOBBY_HTTP_HOST',
    defaultValue: 'localhost');
const LOGGING_LEVEL =
    String.fromEnvironment('CLIENT_LOGGING_LEVEL', defaultValue: 'all');
const LOGGING_ENABLED =
    String.fromEnvironment('CLIENT_LOGGING_ENABLED', defaultValue: 'true') ==
        'true';
const CHAT_PORT = String.fromEnvironment('CHAT_PORT', defaultValue: '4002');
const LOBBY_PORT = String.fromEnvironment('LOBBY_PORT', defaultValue: '4001');
const AUTH_PORT = String.fromEnvironment('AUTH_PORT', defaultValue: '4000');
