import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

class PartyLeader extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final bool crowed;

  const PartyLeader({
    super.key,
    required this.width,
    required this.height,
    this.color,
    this.crowed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      //contrasting shadow
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(alignment: AlignmentDirectional.center, children: [
        crowed
            ? Image.asset(
                Assets.crownedPartyLeader.path,
                width: width,
                height: height,
              )
            : Image.asset(
                Assets.simplePartyLeader.path,
                width: width,
                height: height,
              ),
        HexagonWidget(
          height: height * 0.5,
          inBounds: false,
          color: color ?? Colors.transparent,
          type: HexagonType.POINTY,
        ),
      ]),
    );
  }
}
