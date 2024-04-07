import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';

class MAIN_MENU_CONSTANTS {
  static const buttonWidth = 368.0;
  static const buttonHeight = 89.0;
  static const buttonBorderRadius = 10.0;
  static const buttonPadding = 19.0;
  static const titleStyle = TextStyle(
    color: Color.fromARGB(255, 218, 171, 99),
    fontFamily: FontFamily.prototype,
    shadows: [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black,
      ),
    ],
  );
  static const buttonTextStyle = TextStyle(
    fontSize: 26.0,
    color: Colors.white,
    fontFamily: FontFamily.ubuntu,
    shadows: [
      Shadow(
        color: Colors.black,
        blurRadius: 2,
      ),
    ],
  );
  //if you change image, you need to change buttonBackgroundAreas
  static final buttonsBackgroundImagePath = Assets.buttonsHomepage.planets.path;
}

class GAME_OPTIONS_CONSTANTS {
  static const fontSize = 14.0;
  static const buttonheight = 25.0;
  static const spaceBetweenOptions = 5.0;
  static const internalOptionsPadding = 5.0;
  static const dropdownSelectedItemTextColor = Colors.lightGreenAccent;
  static const blockTitleStyle =
      TextStyle(color: Colors.white, fontSize: fontSize, shadows: [
    Shadow(
      color: Colors.black,
      blurRadius: 2,
    ),
  ]);
}
