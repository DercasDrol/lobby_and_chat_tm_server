import 'package:flutter/material.dart';

class PlanetSlice extends StatelessWidget {
  final String imagePath;
  final int itemIndex;
  final double width;
  final double height;
  final bool useShadow;

  const PlanetSlice({
    super.key,
    required this.imagePath,
    required this.itemIndex,
    required this.width,
    required this.height,
    required this.useShadow,
  });
  getInnerShadow(Widget child) => Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          child,
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(1.0),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(1.0),
                ],
              ),
            ),
          ),
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(1.0),
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(1.0),
                ],
              ),
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    final img = Container(
      height: height,
      width: width,
      child: Image.asset(
        imagePath,
        width: width,
        alignment: FractionalOffset.fromOffsetAndSize(
          Offset(
            0.0,
            height / 8.0 * itemIndex,
          ),
          Size(
            width,
            height,
          ),
        ),
        fit: BoxFit.fitWidth,
      ),
    );
    return useShadow ? getInnerShadow(img) : img;
  }
}
