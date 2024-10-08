import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/red_bordered_Image.dart';

class CostView extends StatelessWidget {
  final String? text;
  final int? cost;
  final double width;
  final double height;
  final bool multiplier;
  final bool useGreyMode;
  final int? discount;
  final bool? useShadow;
  final bool? showRedBoarder;

  const CostView({
    required this.cost,
    required this.width,
    required this.height,
    this.multiplier = false,
    this.useGreyMode = false,
    this.discount,
    this.useShadow,
    this.text,
    this.showRedBoarder,
  });

  @override
  Widget build(BuildContext context) {
    applyGreyMode(child) => useGreyMode
        ? Container(
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.grey,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: child,
          )
        : child;
    getCost(int? costForShowing, double scaleFactor) => applyGreyMode(Container(
          height: height * scaleFactor,
          width: width * scaleFactor,
          decoration: (useShadow ?? false)
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                )
              : null,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            children: [
              Opacity(
                  child: Image(
                    image: AssetImage(Assets.resources.megacredit.path),
                    color: showRedBoarder ?? false ? Colors.red : Colors.black,
                  ),
                  opacity: 0.5),
              Padding(
                padding: EdgeInsets.all(0.5),
                child: showRedBoarder ?? false
                    ? RedBorderedImage(
                        imagePath: Assets.resources.megacredit.path)
                    : Image(
                        image: AssetImage(Assets.resources.megacredit.path)),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.1 * scaleFactor,
                    top: height * 0.08 * scaleFactor,
                    right: width * 0.1 * scaleFactor,
                    left: width * 0.1 * scaleFactor,
                  ),
                  child: FittedBox(
                      child: Text(
                    text ?? costForShowing.toString() + (multiplier ? "X" : ""),
                    style: TextStyle(
                      fontSize: height * 0.8 * scaleFactor,
                      fontFamily: FontFamily.prototype,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ))),
            ],
          ),
        ));
    return discount == null || discount == 0
        ? getCost(cost, 1.0)
        : Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getCost(cost, 1.0),
                  SizedBox(height: height * 0.05),
                  getCost(max(cost! - (discount!), 0), 0.77),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.2),
                child: Icon(
                  Icons.keyboard_double_arrow_down,
                  color: Colors.white,
                  size: height * 0.6,
                  shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                ),
              ),
            ],
          );
  }
}
