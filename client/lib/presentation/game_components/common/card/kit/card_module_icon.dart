import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';

class ModuleIconView extends StatelessWidget {
  final double iconRadius;

  const ModuleIconView({
    required this.module,
    required this.iconRadius,
  });
  final GameModule module;
  @override
  Widget build(BuildContext context) {
    Widget getImage() {
      switch (module) {
        case GameModule.PRELUDE2:
          return Stack(children: [
            Image(image: AssetImage(Assets.cardModuleIcons.prelude.path)),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Image(
                image: AssetImage(Assets.prelude2.prelude2Triangle16.path),
              ),
            )
          ]);
        default:
          return module.toIconPath() == null
              ? SizedBox.shrink()
              : Image(image: AssetImage(module.toIconPath()!));
      }
    }

    return SizedBox(
      height: iconRadius,
      width: iconRadius,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0),
              offset: Offset(0.0, 0.0),
              blurRadius: 0.2,
              spreadRadius: 0.2,
            )
          ],
        ),
        child: getImage(),
      ),
    );
  }
}
