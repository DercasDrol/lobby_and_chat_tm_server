import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

class ChairmanCrown extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const ChairmanCrown(
      {super.key, required this.width, required this.height, this.color});

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
            blurRadius: 12,
            spreadRadius: 5.5,
          ),
        ],
      ),
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Image.asset(
          Assets.chairmanCrown.path,
          width: width,
          height: height,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: width * 0.024,
            bottom: width * 0.09,
          ),
          child: Container(
            width: width * 0.55,
            height: width * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                ),
                BoxShadow(
                  color: color ?? Colors.transparent,
                  spreadRadius: -0.5,
                  blurRadius: 0.5,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
