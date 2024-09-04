import 'dart:async';
import 'dart:convert';
import 'package:web/web.dart' as html;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/common/socket.dart';
import 'package:mars_flutter/data/api/constants.dart';
import 'package:mars_flutter/data/storage.dart';

class AuthAPIClient {
  static final Completer<String> _gameServerFutureCompleter = new Completer();
  final Future<String> gameServer = _gameServerFutureCompleter.future;
  final ValueNotifier<String?> jwt = ValueNotifier(null);
  final ValueNotifier<String?> authUrl = ValueNotifier(null);
  final _socket = getNewSocketInstance(AUTH_PORT);

  void getGameHost() async {
    final host = html.window.location.hostname;
    final _protocol = host.startsWith("localhost") ? "http://" : "https://";
    final url = _protocol + host + ":" + AUTH_PORT + "/game_server/";
    final response =
        await http.get(Uri.parse(url), headers: {'Content-Type': 'text/plain'});
    if (response.statusCode == 200) {
      _gameServerFutureCompleter.complete(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load server host');
    }
  }

  AuthAPIClient() {
    logger.d('AuthApiClient init');
    checkJwtInStorage();
    getGameHost();
    _socket.on('connect', (_) {
      logger.d('trying to login');
      _socket.emit('login');
    });

    _socket.on('error', (err) {
      logger.d('AuthAPIClient onError:$err');
    });

    _socket.on('auth_url', (authUrl) {
      logger.d('AuthApiClient handle(auth_url): $authUrl');
      if (this.authUrl.value != authUrl)
        this.authUrl.value = authUrl.toString();
    });

    _socket.on('jwt', (jwtToken) {
      logger.d('AuthApiClient handle(jwt)');
      secureStorage.write(key: 'jwt', value: jwtToken);
      this.jwt.value = jwtToken;
    });

    this.jwt.addListener(() {
      logger.d('AuthApiClient isTokenOk.addListener: ${this.jwt.value}');
      if (this.jwt.value == null) {
        initAuth();
      } else {
        _socket.disconnect();
      }
    });
  }

  void dispose() {
    _socket.dispose();
    jwt.dispose();
    authUrl.dispose();
  }

  void checkJwtInStorage() async {
    final jwtFromStorage = await secureStorage.read(key: 'jwt');
    if (jwtFromStorage != null) {
      logger.d('AuthApiClient have found jwt in storage');
      this.jwt.value = jwtFromStorage;
    }
  }

  void initAuth() {
    logger.d('initAuth()');
    if (_socket.connected) _socket.disconnect();
    _socket.connect();
  }
}
