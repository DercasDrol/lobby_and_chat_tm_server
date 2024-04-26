import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/lobby_category.dart';
import 'package:mars_flutter/presentation/game_components/common/lobby_elements_tabs.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/lobby_view/kit/games_list/games_list.dart';
import 'package:tab_container/tab_container.dart';

class LobbyView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final double width;
  final double height;

  const LobbyView({
    super.key,
    required this.lobbyCubit,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buildGameList = (lobbyCategory) => GamesList(
        lobbyCubit: lobbyCubit, height: height, lobbyCategory: lobbyCategory);

    return LobbyElementsTabs(
      width: width,
      height: height,
      children: [
        Column(children: [
          buildGameList(LobbyCategory.GAMES_TO_JOIN),
          Container(
            padding: EdgeInsets.all(5),
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: BottomButton(
              text: 'Create New Game',
              onPressed: () => //new game will be created and sent to the server
                  //server will send back the game id
                  //and the game settings will be shown instead of the LobbyView
                  lobbyCubit.createNewGame(),
            ),
          ),
        ]),
        buildGameList(LobbyCategory.OWN_GAMES),
        buildGameList(LobbyCategory.GAMES_TO_WATCH),
      ],
      tabsNames: ["Look for Games", "Your Games", "Games to Watch"],
      //controller: controller,
    );
  }
}
