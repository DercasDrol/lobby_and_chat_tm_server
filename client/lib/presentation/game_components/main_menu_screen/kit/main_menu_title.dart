import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/main_menu_screen/kit/planet_slice.dart';

class MainMenuTitle extends StatelessWidget {
  final String topPartText;
  final String bottomPartText;
  final double width;
  final double height;
  final String imagePath;
  final TextStyle textStyle;

  const MainMenuTitle({
    super.key,
    required this.topPartText,
    required this.bottomPartText,
    required this.width,
    required this.height,
    required this.imagePath,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          PlanetSlice(
            itemIndex: 0,
            imagePath: imagePath,
            width: width,
            height: height,
            useShadow: true,
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 15.0, left: 27.0, right: 27.0, bottom: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    topPartText,
                    style: textStyle.copyWith(
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    bottomPartText,
                    style: textStyle.copyWith(
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
