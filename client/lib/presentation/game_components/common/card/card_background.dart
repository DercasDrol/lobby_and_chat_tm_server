import 'package:flutter/material.dart';

class CardBackground extends StatelessWidget {
  final double padding;
  final double borderRadius;
  final Color? color;
  final bool isSelected;

  const CardBackground({
    required this.padding,
    required this.borderRadius,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 153, 0),
                    spreadRadius: 4,
                    blurRadius: 2,
                  )
                ]
              : null,
          color: color,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(),
        ),
      ),
    );
  }
}
