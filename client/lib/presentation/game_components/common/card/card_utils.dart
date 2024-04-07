import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:mars_flutter/domain/model/card/render/CardRenderItemType.dart';

class RedItemBox extends StatelessWidget {
  final Widget child;
  final double width;
  final ItemShape shape;
  const RedItemBox({
    super.key,
    required this.child,
    required this.shape,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    const color = Colors.red;
    switch (shape) {
      case ItemShape.circle:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width),
            boxShadow: [
              BoxShadow(
                color: color,
                spreadRadius: width * 0.01,
              )
            ],
          ),
          width: width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: child,
          ),
        );
      case ItemShape.square:
        return Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: color,
                //blurRadius: 1,
                spreadRadius: width * 0.01,
              )
            ],
          ),
          width: width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: child,
          ),
        );
      case ItemShape.hexagon:
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: width,
            maxHeight: width,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              HexagonWidget.pointy(width: width, color: Colors.red),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: child)
            ],
          ),
        );
      case ItemShape.triangle:
        return Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: color,
                //blurRadius: 1,
                spreadRadius: width * 0.01,
              )
            ],
          ),
          width: width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: child,
          ),
        );
    }
  }
}
