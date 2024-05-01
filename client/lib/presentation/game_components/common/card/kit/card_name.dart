import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/domain/model/card/CardName.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';

class CardNameView extends StatelessWidget {
  final CardName name;
  final CardType type;
  final double? width;
  final double height;
  final double? topPadding;

  const CardNameView({
    required this.name,
    this.width,
    required this.height,
    this.topPadding,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final width = this.width ?? 300.0;
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      child: SizedBox(
        width: this.width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: this.type.toColor(),
          ),
          child: FittedBox(
            fit: this.width == null ? BoxFit.fitHeight : BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.only(
                left: width * 0.02,
                right: width * 0.02,
                top: this.width == null ? height * 0.1 : 0.0,
                bottom: this.width == null ? height * 0.1 : 0.0,
              ),
              child: Text(
                name.toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.prototype,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
