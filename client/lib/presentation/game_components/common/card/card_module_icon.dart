import 'package:flutter/material.dart';
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
    String? imagePath = module.toIconPath();
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
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            imagePath == null
                ? SizedBox.shrink()
                : Image(image: AssetImage(imagePath)),
          ],
        ),
      ),
    );
  }
}
