import 'package:flutter/material.dart';

class OnHoverZoom extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final double ratio;

  const OnHoverZoom(
      {Key? key,
      required this.child,
      required this.width,
      required this.height,
      required this.ratio})
      : super(key: key);
  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHoverZoom> {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: Center(
            child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.width,
            minHeight: widget.height,
            maxWidth: widget.width,
            maxHeight: widget.height,
          ),
          child: AnimatedScale(
            filterQuality: FilterQuality.high,
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            child: widget.child,
          ),
        )));
  }

  void onEntered(bool isHovered) {
    setState(() {
      this._scale = isHovered ? widget.ratio : 1.0;
    });
  }
}
