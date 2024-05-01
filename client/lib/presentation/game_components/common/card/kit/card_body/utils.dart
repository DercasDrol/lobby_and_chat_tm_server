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
  Widget _coverItem(Widget child, double? width) {
    return Container(
        width: width,
        height: parentHeight,
        child: Center(
            child: Container(
          width: width,
          height: height,
          child: Center(child: child),
        )));
  }

  Widget _createTextItem(String text) {
    return _coverItem(
        Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            fontSize: height * 0.7,
            fontFamily: FontFamily.prototype,
            color: Colors.black,
            height: 1.0,
          ),
        ),
        text.length * width);
  }

  @override
  Widget build(BuildContext context) {
    return text == null
        ? _coverItem(child == null ? SizedBox.shrink() : child!, width)
        : _createTextItem(text!);
  }
}

class CrossView extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  const CrossView(
      {super.key,
      required this.size,
      required this.color,
      required this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CrossDrawPaint(color: color, strokeWidth: strokeWidth),
        child: Container(),
      ),
    );
  }
}

class CrossDrawPaint extends CustomPainter {
  final Color color;
  final double strokeWidth;
  CrossDrawPaint({required this.color, required this.strokeWidth});
  @override
  void paint(Canvas canvas, Size size) {
    Paint crossBrush = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), crossBrush);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), crossBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
