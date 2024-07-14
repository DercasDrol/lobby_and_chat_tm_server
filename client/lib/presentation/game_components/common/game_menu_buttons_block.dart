import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';

class GameMenuButtonsBlock extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final double width;
  final double height;
  const GameMenuButtonsBlock({
    super.key,
    required this.lobbyCubit,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        BottomButton(
          text: 'Go to lobby',
          onPressed: () {
            lobbyCubit.closeGameSession();
            context.go(LOBBY_ROUTE);
          },
        ),
        BottomButton(
          text: 'Change client',
          onPressed: () {
            final cClient = localStorage.getItem(SELECTED_GAME_CLIENT);
            localStorage.setItem(
                SELECTED_GAME_CLIENT,
                cClient == GAME_CLIENT_ROUTE
                    ? NEW_GAME_CLIENT_ROUTE
                    : GAME_CLIENT_ROUTE);
            context.go(cClient == GAME_CLIENT_ROUTE
                ? NEW_GAME_CLIENT_ROUTE
                : GAME_CLIENT_ROUTE);
          },
        ),
      ]),
    );
  }
}
