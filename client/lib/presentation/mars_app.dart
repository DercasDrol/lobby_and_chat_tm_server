import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/game_cubit.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/lobby_state.dart';
import 'package:mars_flutter/domain/logs_cubit.dart';
import 'package:mars_flutter/domain/model/Phase.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'dart:html' as html;
import 'package:mars_flutter/domain/repositories.dart';

import 'package:mars_flutter/presentation/game_components/auth_screen/auth_screen.dart';

import 'package:mars_flutter/presentation/game_components/cards_screen/cards_screen.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/game_screen.dart';

import 'package:mars_flutter/presentation/game_components/iframe_game_screen/iframe_game_screen.dart';

import 'package:mars_flutter/presentation/game_components/lobby_screen/lobby_screen.dart';

import 'package:mars_flutter/presentation/game_components/main_menu_screen/main_menu_screen.dart';

class MarsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lobbyCubit = LobbyCubit(Repositories.lobby)..init();
    final gameChatCubit = ChatCubit(Repositories.chat, null)..init();
    final generalChatCubit = ChatCubit(Repositories.chat, "General")..init();
    final LogsCubit logsCubit = LogsCubit(
      repository: Repositories.game,
    );
    final GameCubit gameCubit = GameCubit(
      repository: Repositories.game,
      additionalOnChangeFn: (
        List<PublicPlayerModel>? players,
        int generation,
        ParticipantId participantId,
      ) =>
          logsCubit.getGameLogs(players, generation, participantId),
    );
    //change chat channel when a game selection changed
    lobbyCubit.stream.listen((state) {
      if (gameChatCubit.state.chatKey != state.gameIdToAction?.toString())
        gameChatCubit.chatKey = state.gameIdToAction?.toString();
    });

    final GoRouter _router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const MainMenuScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'auth',
              builder: (BuildContext context, GoRouterState state) =>
                  AuthScreen(Repositories.auth.authUrl),
            ),
            GoRoute(
                path: 'game_client',
                builder: (BuildContext context, GoRouterState state) {
                  localStorage.setItem(SELECTED_GAME_CLIENT, GAME_CLIENT_ROUTE);
                  return BlocBuilder<LobbyCubit, LobbyState>(
                    bloc: lobbyCubit,
                    builder: (context, state) {
                      if (lobbyCubit.needGoToGame) {
                        return IframeGameScreen(
                          lobbyCubit: lobbyCubit,
                          gameChatCubit: gameChatCubit,
                          generalChatCubit: generalChatCubit,
                        );
                      } else {
                        context.go(LOBBY_ROUTE);
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }),
            GoRoute(
                path: 'new_game_client',
                builder: (BuildContext context, GoRouterState state) {
                  localStorage.setItem(
                      SELECTED_GAME_CLIENT, NEW_GAME_CLIENT_ROUTE);
                  return BlocBuilder<LobbyCubit, LobbyState>(
                    bloc: lobbyCubit,
                    builder: (context, state) {
                      if (lobbyCubit.needGoToGame) {
                        return GameScreen(
                          lobbyCubit: lobbyCubit,
                          gameChatCubit: gameChatCubit,
                          generalChatCubit: generalChatCubit,
                          logsCubit: logsCubit,
                          gameCubit: gameCubit,
                        );
                      } else {
                        context.go(LOBBY_ROUTE);
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }),
            GoRoute(
              path: 'lobby',
              builder: (BuildContext context, GoRouterState state) =>
                  MainLobbyScreen(
                gameChatCubit: gameChatCubit,
                generalChatCubit: generalChatCubit,
                lobbyCubit: lobbyCubit,
              ),
            ),
            GoRoute(
              path: 'cards',
              builder: (BuildContext context, GoRouterState state) =>
                  const CardsScreen(),
            ),
          ],
        ),
      ],
    );
    String targetRoute = _router.routeInformationProvider.value.uri.path;
    gameCubit.stream.listen((state) {
      //currently new client have no end game screen so we need to redirect to the olg client on the end phase
      if (state.viewModel?.game.phase == Phase.END) {
        gameCubit.setParticipant(null);
        _router.routeInformationProvider.go(GAME_CLIENT_ROUTE);
      }
    });
    //we need call this function each time when jwt or route changed
    final listener = () {
      final jwt = Repositories.auth.jwt.value;

      final cRoute = _router.routeInformationProvider.value.uri.path;
      final userId = lobbyCubit.userId;
      final gameIdToAction = lobbyCubit.state.gameIdToAction;
      if (userId != null && gameIdToAction != null)
        localStorage.setItem(userId, gameIdToAction.toString());
      else if (gameIdToAction != null) localStorage.removeItem(userId!);
      logger.d("CurrentRoute: ${cRoute} isTokenOk: ${jwt}");
      final jwtIsOk = jwt != null && jwt != "";

      if (!jwtIsOk &&
          [LOBBY_ROUTE, GAME_CLIENT_ROUTE, NEW_GAME_CLIENT_ROUTE]
              .contains(cRoute)) {
        targetRoute = cRoute;
        _router.routeInformationProvider.go(AUTH_ROUTE);
      } else if (jwtIsOk &&
          cRoute == AUTH_ROUTE &&
          [GAME_CLIENT_ROUTE, NEW_GAME_CLIENT_ROUTE].contains(targetRoute) &&
          userId != null) {
        final gameIdToAction = localStorage.getItem(userId);
        if (gameIdToAction != null) {
          lobbyCubit.continueGame(int.parse(gameIdToAction));
        }
        _router.routeInformationProvider.go(targetRoute);
      } else if (jwtIsOk && cRoute == AUTH_ROUTE) {
        _router.routeInformationProvider.go(LOBBY_ROUTE);
      } else if (cRoute == AUTH_ROUTE) {
        Repositories.auth.initAuth();
      }

      if (jwtIsOk &&
          [LOBBY_ROUTE, GAME_CLIENT_ROUTE, NEW_GAME_CLIENT_ROUTE]
              .contains(cRoute) &&
          !Repositories.chat.isChatConnectionOk.value) {
        Repositories.chat.initConnectionToChatServer(jwt);
      }
      if (jwtIsOk && LOBBY_ROUTE == cRoute && lobbyCubit.needGoToGame) {
        _router.routeInformationProvider.go(
            localStorage.getItem(SELECTED_GAME_CLIENT) ?? GAME_CLIENT_ROUTE);
      }
      if (![NEW_GAME_CLIENT_ROUTE].contains(cRoute))
        gameCubit.setParticipant(null);
    };

    Repositories.auth.jwt.addListener(listener);

    _router.routeInformationProvider.addListener(listener);

    listener();

    html.window.addEventListener('beforeunload', (event) {
      logger.d("onBeforeUnload event: $event");
      _router.routeInformationProvider.dispose();
      Repositories.auth.dispose();
      Repositories.chat.dispose();
      Repositories.lobby.dispose();
      lobbyCubit.close();
      gameChatCubit.close();
      generalChatCubit.close();
      return null;
    });

    return MaterialApp.router(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      routerConfig: _router,
      onNavigationNotification:
          (NavigationNotification navigationNotification) {
        logger.d("onNavigationNotification: $navigationNotification");
        return true;
      },
    );
  }

  MarsApp();
}
