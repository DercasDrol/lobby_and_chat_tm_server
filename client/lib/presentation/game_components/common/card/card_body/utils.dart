import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/fonts.gen.dart';

class BodyItemCover extends StatelessWidget {
  const BodyItemCover({
    required this.width,
    required this.height,
    this.child,
    this.text,
    required this.parentHeight,
  });
  final double width;
  final double height;
  final double parentHeight;
  final Widget? child;
  final String? text;
  Widget _coverItem(Widget child) {
    return SizedBox(
        width: width,
        height: parentHeight,
        child: Center(
            child: SizedBox(
          width: width,
          height: height,
          child: Center(child: child),
        )));
  }

  Widget _createTextItem(String text) {
    return _coverItem(Text(
      text,
      style: TextStyle(
        fontSize: height * 0.7,
        fontFamily: FontFamily.prototype,
        color: Colors.black,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return text == null
        ? _coverItem(child == null ? SizedBox.shrink() : child!)
        : _createTextItem(text!);
  }
}
