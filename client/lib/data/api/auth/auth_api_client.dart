import 'package:flutter/foundation.dart';

import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/data/api/common/socket.dart';
import 'package:mars_flutter/data/storage.dart';

class AuthAPIClient {
  final ValueNotifier<String?> jwt = ValueNotifier(null);
  final ValueNotifier<String?> authUrl = ValueNotifier(null);
  final _socket = getNewSocketInstance('4000');

  AuthAPIClient() {
    logger.d('AuthApiClient init');
    checkJwtInStorage();

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
