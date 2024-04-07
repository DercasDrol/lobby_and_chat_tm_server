import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class GenerationView extends StatelessWidget {
  final int generationValue;
  final double size;
  const GenerationView({
    required this.generationValue,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              Assets.board.marsHd.path,
            ),
            fit: BoxFit.fill,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(top: size * 0.1),
                    child: FittedBox(
                        child: Text("GEN",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.3,
                            ))))),
            Expanded(
                flex: 7,
                child: Padding(
                    padding: EdgeInsets.only(bottom: size * 0.05),
                    child: FittedBox(
                        child: Text(generationValue.toString(),
                            style: MAIN_TEXT_STYLE))))
          ],
        ));
  }
}
