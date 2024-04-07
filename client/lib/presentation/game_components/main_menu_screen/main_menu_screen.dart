import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/stars_background.dart';
import 'package:mars_flutter/presentation/game_components/main_menu_screen/kit/main_menu_button.dart';
import 'package:mars_flutter/presentation/game_components/main_menu_screen/kit/main_menu_title.dart';
import 'package:mars_flutter/presentation/game_components/main_menu_screen/kit/planet_slice.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MAIN_MENU_CONSTANTS.buttonWidth;
    final height = MAIN_MENU_CONSTANTS.buttonHeight;
    final imagePath = MAIN_MENU_CONSTANTS.buttonsBackgroundImagePath;
    createMenuButton(
            {required int itemIndex,
            required String text,
            String? route,
            String? link}) =>
        MainMenuButton(
          itemIndex: itemIndex,
          text: text,
          route: route,
          link: link,
          width: width,
          height: MAIN_MENU_CONSTANTS.buttonHeight,
          textStyle: MAIN_MENU_CONSTANTS.buttonTextStyle,
          imagePath: imagePath,
        );

    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          StarsBackground(),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MainMenuTitle(
                  topPartText: 'TERRAFORMING',
                  bottomPartText: 'MARS',
                  width: width,
                  imagePath: imagePath,
                  height: MAIN_MENU_CONSTANTS.buttonHeight,
                  textStyle: MAIN_MENU_CONSTANTS.titleStyle,
                ),
                createMenuButton(
                    itemIndex: 1, route: LOBBY_ROUTE, text: 'PLAY'),

                createMenuButton(
                    itemIndex: 2,
                    text: 'HOW TO PLAY',
                    link:
                        "https://github.com/terraforming-mars/terraforming-mars/wiki/Rulebooks"),
                //TODO: open in new tab or show flutter version?
                createMenuButton(
                    itemIndex: 3, route: CARDS_ROUTE, text: 'CARDS LIST'),
                createMenuButton(
                    itemIndex: 4,
                    text: 'BOARD GAME',
                    link:
                        "https://boardgamegeek.com/boardgame/167791/terraforming-mars"),
                createMenuButton(
                    itemIndex: 5,
                    text: 'ABOUT US',
                    link:
                        "https://github.com/terraforming-mars/terraforming-mars#README"),
                createMenuButton(
                    itemIndex: 6,
                    text: 'WHATS NEW?',
                    link:
                        "https://github.com/terraforming-mars/terraforming-mars/wiki/Changelog"),
                createMenuButton(
                    itemIndex: 7,
                    text: 'JOIN US ON DISCORD',
                    link: "https://discord.gg/afeyggbN6Y"),
                PlanetSlice(
                  itemIndex: 8,
                  imagePath: imagePath,
                  width: width,
                  height: height,
                  useShadow: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
