import 'package:flutter/material.dart';

class HexagonBuilder extends StatefulWidget {
  final List<Widget> children;
  final bool useAnimation;
  final void Function()? onClick;

  const HexagonBuilder({
    super.key,
    required this.children,
    required this.useAnimation,
    required this.onClick,
  });

  @override
  State<HexagonBuilder> createState() => _HexagonBuilderState();
}

class _HexagonBuilderState extends State<HexagonBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _AnimationHexForChoose;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        value: 1.0,
        vsync: this,
        duration: Duration(milliseconds: 3000),
        animationBehavior: AnimationBehavior.normal);
    _AnimationHexForChoose =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useAnimation) {
      _controller.reverse();
      this._controller.addListener(() {
        final double v = _controller.value;
        !widget.useAnimation && v > 0.99
            ? _controller.stop()
            : v > 0.99
                ? _controller.reverse()
                : v <= 0.7
                    ? _controller.forward()
                    : null;
      });
    }
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
      onPressed: widget.useAnimation ? widget.onClick : null,
      child: FadeTransition(
        opacity: _AnimationHexForChoose,
        child: Stack(
          alignment: Alignment.center,
          children: widget.children,
        ),
      ),
    );
  }
}
