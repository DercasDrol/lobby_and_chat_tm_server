import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mars_flutter/presentation/game_components/main_menu_screen/kit/planet_slice.dart';
import 'package:url_launcher/url_launcher.dart';

class MainMenuButton extends StatelessWidget {
  ///using for backgroung image
  final int itemIndex;
  final String text;
  final String? route;
  final String? link;
  final double width;
  final double height;
  final TextStyle textStyle;
  final String imagePath;
  const MainMenuButton({
    super.key,
    required this.text,
    this.route,
    this.link,
    required this.itemIndex,
    required this.width,
    required this.height,
    required this.textStyle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: Container(
          height: height,
          width: width,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              PlanetSlice(
                itemIndex: itemIndex,
                imagePath: imagePath,
                width: width,
                height: height,
                useShadow: false,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(text, style: textStyle),
              ),
              MaterialButton(
                onPressed: () => route != null
                    ? context.go(route!)
                    : link != null
                        ? launchUrl(Uri.parse(link!))
                        : null,
                hoverColor: Colors.white12,
                elevation: 0,
                padding: EdgeInsets.zero,
                child: Container(
                  height: height,
                  width: width,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
