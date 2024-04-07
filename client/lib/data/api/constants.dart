import 'dart:html' as html;

import 'package:flutter/foundation.dart';

final AUTH_CHAT_LOBBY_HOST = kIsWeb
    ? html.window.location.host
    : String.fromEnvironment('AUTH_CHAT_LOBBY_HOST', defaultValue: 'localhost');
final AUTH_CHAT_LOBBY_PROTOCOL = AUTH_CHAT_LOBBY_HOST == 'localhost'
    ? 'http'
    : String.fromEnvironment('AUTH_CHAT_LOBBY_PROTOCOL', defaultValue: 'http');
const CHAT_PORT = String.fromEnvironment('CHAT_PORT', defaultValue: '4002');
const LOBBY_PORT = String.fromEnvironment('LOBBY_PORT', defaultValue: '4001');
const AUTH_PORT = String.fromEnvironment('AUTH_PORT', defaultValue: '4000');
const GAME_SERVER_HOST = 'terraforming-mars.herokuapp.com';
const GAME_SERVER_PROTOCOL =
    String.fromEnvironment('GAME_SERVER_PROTOCOL', defaultValue: 'https');
